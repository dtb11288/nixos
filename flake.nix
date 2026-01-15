{
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For command-not-found
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-programs-sqlite, ... }@inputs:
  let
    theme = import ./theme.nix;
    secrets = nixpkgs.lib.pipe ./secrets [
      (builtins.readDir)
      (builtins.attrNames)
      (builtins.filter (name: builtins.match ".*\\.json" name != null))
      (map (name:
        let
          content = builtins.fromJSON (builtins.readFile "${self}/secrets/${name}");
          key = nixpkgs.lib.removeSuffix ".json" name;
        in { ${key} = content; }
      ))
      (nixpkgs.lib.lists.foldr (acc: config: acc // config) {})
    ];
    username = secrets.user.name;
    stateVersion = "25.11";
    nixpkgsConfig = { ... }:
    {
      nixpkgs = {
        # Import all .nix files in the overlays directory
        overlays = nixpkgs.lib.pipe ./overlays [
          (builtins.readDir)
          (builtins.attrNames)
          (builtins.filter (name: builtins.match ".*\\.nix" name != null))
          (map (name: import ./overlays/${name}))
        ];
        # Configure your nixpkgs instance
        config = {
          # Disable if you don't want unfree packages
          allowUnfree = true;
          # Workaround for https://github.com/nix-community/home-manager/issues/2942
          allowUnfreePredicate = (_: true);
        };
      };
    };
    makeArgs = { dpi, system, ... }@config: config // {
      # Pass flake inputs to our config
      dpiRatio = dpi / 96;
      programs-sqlite-db = flake-programs-sqlite.packages.${system}.programs-sqlite;
      inherit inputs theme secrets username stateVersion;
    };
    mkHomeManagerConfig = { system, ... }@config:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = makeArgs config;
        modules = [ nixpkgsConfig ./home/home.nix ];
      };
    mkNixosSystem = { hostname, system, ... }@config:
      let args = makeArgs config;
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = args;
        modules = [
          nixpkgsConfig
          ./configuration.nix
          ./system/${hostname}/hardware.nix
          ./system/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/home.nix;
            home-manager.extraSpecialArgs = args;
          }
        ];
      };
    mkConfigs = systems: {
      nixosConfigurations = builtins.mapAttrs (hostname: config: mkNixosSystem (config // { inherit hostname; })) systems;
      homeConfigurations = builtins.mapAttrs (hostname: config:
        let
          userAtHost = "${username}@${hostname}";
        in
        {
          ${userAtHost} = mkHomeManagerConfig (config // { inherit hostname; });
        }
      ) systems;
    };
    # Read specific system configurations from the ./system directory for each hostname
    hosts = nixpkgs.lib.pipe ./system [
      (builtins.readDir)
      (nixpkgs.lib.filterAttrs (name: type: type == "directory"))
      (builtins.attrNames)
      (map (hostname: { name = hostname; value = import ./system/${hostname}/config.nix; }))
      (builtins.listToAttrs)
    ];
  in
  mkConfigs hosts;
}

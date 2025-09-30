{
  description = "Your new nix config";

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
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    username = secrets.username;
    nixpkgsConfig = { ... }:
    {
      nixpkgs = {
        overlays = nixpkgs.lib.pipe ./overlays [
          (builtins.readDir)
          (builtins.attrNames)
          (builtins.filter (name: builtins.match ".*\\.nix" name != null))
          (map (name: import ./overlays/${name}))
        ];
        # Configure your nixpkgs instance
        config = {
          permittedInsecurePackages = [];
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
      inherit inputs theme secrets username;
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

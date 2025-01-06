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
    makeArgs = { dpi, system, ... }@config: config // {
      # Pass flake inputs to our config
      dpiRatio = dpi / 96;
      programs-sqlite-db = flake-programs-sqlite.packages.${system}.programs-sqlite;
      inherit inputs theme secrets;
    };
    mkHomeManagerConfig = { system, ... }@config:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = makeArgs config;
        modules = [ nixpkgsConfig ./home/home.nix ];
      };
    mkNixosSystem = { hostname, username, system, ... }@config:
      let args = makeArgs config;
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = args;
        modules = [
          nixpkgsConfig
          ./system/${hostname}.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home/home.nix;
            home-manager.extraSpecialArgs = args;
          }
        ];
      };
    mkConfigs = username: systems: {
      nixosConfigurations = builtins.mapAttrs (hostname: config: mkNixosSystem (config // { inherit hostname username; })) systems;
      homeConfigurations = builtins.mapAttrs (hostname: config:
        let
          userAtHost = "${username}@${hostname}";
        in
        {
          ${userAtHost} = mkHomeManagerConfig (config // { inherit hostname username; });
        }
      ) systems;
    };
    nixpkgsConfig = { ... }: {
      nixpkgs = {
        overlays = [
          (import ./overlays/chromium.nix)
          (import ./overlays/rofi.nix)
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
  in
  mkConfigs "binh" {
    xps15 = { dpi = 192; system = "x86_64-linux"; };
    t14 = { dpi = 96; system = "x86_64-linux"; };
    pc = { dpi = 144; system = "x86_64-linux"; };
  };
}

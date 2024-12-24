{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    theme = import ./theme.nix;
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    makeArgs = { dpi, ... }@config: config // {
      # Pass flake inputs to our config
      dpiRatio = dpi / 96;
      inherit inputs theme secrets;
    };
    mkHomeManagerConfig = config:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${nixpkgs.system};
        extraSpecialArgs = makeArgs config;
        modules = [ nixpkgsConfig ./home/home.nix ];
      };
    mkNixosSystem = { hostname, username, ... }@config:
      let args = makeArgs config;
      in nixpkgs.lib.nixosSystem {
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
    xps15 = { dpi = 192; };
    t14 = { dpi = 96; };
    pc = { dpi = 144; };
  };
}

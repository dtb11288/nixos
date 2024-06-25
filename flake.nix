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
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    theme = import ./theme.nix;
    makeArgs = username: hostname: dpi: {
      # Pass flake inputs to our config
      inherit inputs theme dpi hostname username secrets;
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
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      xps15 = let
        args = makeArgs "binh" "xps15" 192;
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = args;
        # > Our main nixos configuration file <
        modules = [
          nixpkgsConfig
          ./system/xps15.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.binh = import ./home/home.nix;
            home-manager.extraSpecialArgs = args;
          }
        ];
      };
      t14 = let
        args = makeArgs "binh" "t14" 96;
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = args;
        # > Our main nixos configuration file <
        modules = [
          nixpkgsConfig
          ./system/t14.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.binh = import ./home/home.nix;
            home-manager.extraSpecialArgs = args;
          }
        ];
      };
      pc = let
        args = makeArgs "binh" "pc" 144;
      in
      nixpkgs.lib.nixosSystem {
        specialArgs = args;
        # > Our main nixos configuration file <
        modules = [
          nixpkgsConfig
          ./system/pc.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.binh = import ./home/home.nix;
            home-manager.extraSpecialArgs = args;
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "binh@xps15" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = makeArgs "binh" "xps15" 192;
        # > Our main home-manager configuration file <
        modules = [ nixpkgsConfig ./home/home.nix ];
      };
      "binh@t14" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = makeArgs "binh" "t14" 96;
        # > Our main home-manager configuration file <
        modules = [ nixpkgsConfig ./home/home.nix ];
      };
      "binh@pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = makeArgs "binh" "pc" 144;
        # > Our main home-manager configuration file <
        modules = [ nixpkgsConfig ./home/home.nix ];
      };
    };
  };
}

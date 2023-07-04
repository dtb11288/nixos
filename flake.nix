{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    theme = import ./theme.nix;
  in
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      xps15 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostname = "xps15";
          username = "binh";
        }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./system/xps15.nix ];
      };
      pc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostname = "pc";
          username = "binh";
        }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./system/pc.nix ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "binh@xps15" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          inherit theme;
          factor = 0.75; # 144/192
          hostname = "xps15";
          username = "binh";
        }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home/home.nix ];
      };
      "binh@pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          inherit theme;
          factor = 1; # 144/192
          hostname = "pc";
          username = "binh";
        }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home/home.nix ];
      };
    };
  };
}

# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ username, pkgs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./theme.nix
    ./zsh.nix
    ./alacritty.nix
    ./lazygit.nix
    ./zellij.nix
    ./rofi.nix
    ./dunst.nix
    ./fzf.nix
    ./sxhkd.nix
    ./git.nix
    ./telegram.nix
    ./lf.nix
    ./flameshot.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    rustup
    silver-searcher
    ripgrep
    firefox
    google-chrome
    thunderbird
    birdtray
    lm_sensors
    pciutils
    slack
    dbeaver
    lshw
    gimp
    spotify-player
    openssl
    libreoffice
    onlyoffice-bin
    flameshot
    zip
    unzip
    unrar
    nomacs
    darktable
    (xfce.thunar.override { thunarPlugins = with pkgs; [ xfce.thunar-volman xfce.thunar-archive-plugin ]; })
    xarchiver
    postman
    zathura
    mpv
    gimp
    lazydocker
    nil
    mariadb-client
    sqlite
    lxtask
    lxappearance
    tree
    discord
    leafpad
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Enable xsession service, for some programs
  xsession = {
    enable = true;
    initExtra = with pkgs; ''
      ${birdtray}/bin/birdtray &
      ${flatpak}/bin/flatpak run com.synology.SynologyDrive &
    '';
  };

  # Direnv support
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

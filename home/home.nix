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
    ./sxhkd
    ./git.nix
    ./flameshot.nix
    ./helix.nix
    ./vim
    ./tmux.nix
    ./xmonad
    ./rbw.nix
    ./aria2.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  home.sessionPath = [
    "/home/${username}/opt/bin"
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    telegram-desktop
    zapzap
    firefox
    google-chrome
    ungoogled-chromium
    thunderbird
    birdtray
    # TODO: Remove this later
    # audacity
    slack
    gimp3
    onlyoffice-bin
    flameshot
    nomacs
    darktable
    rawtherapee
    hugin
    blender
    inkscape
    zathura
    mpv
    lxtask
    lxappearance
    discord
    xfce.mousepad
    jellyfin-media-player
    supersonic
    weechat
    qbittorrent
    simplescreenrecorder
    stremio
  ];

  # Wallpaper
  home.file.".background-image".source = ./wallpaper;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Enable xsession service, for some programs
  xsession.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi
    rofi-rbw
    pinentry-gtk2
    polybar
    alacritty
    xsel
    dunst
    libnotify
    glib
    pavucontrol
    blueman
    xdg_utils
    slock
    volumeicon
    parcellite
    xdotool
    playerctl
    feh
    sxhkd
    pamixer
    solaar
  ];

  programs.nm-applet.enable = true;

  location = {
    provider = "manual"; #"geoclue2";
    latitude = 21.0;
    longitude = 105.0;
  };

  services.redshift = {
    enable = true;
    temperature = {
      day = 5000;
      night = 4000;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-unikey
    ];
  };

  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.99;
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = 0.75;
  };
  services.tumbler.enable = true;
  services.blueman.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };

  services.xserver = {
    enable = true;
    layout = "us";

    excludePackages = with pkgs; [
      xterm
    ];

    windowManager.leftwm = {
      enable = true;
    };

    xautolock = {
      enable = true;
      locker = "/run/wrappers/bin/slock";
      time = 5;
      extraOptions = [ "-detectsleep" "-corners '0-00'" ];
    };

    displayManager = {
      defaultSession = "none+leftwm";
      lightdm = {
        enable = true;
      };
      autoLogin.enable = true;
      autoLogin.user = username;

      sessionCommands = with pkgs; ''
        ${xorg.xset}/bin/xset r rate 200 25
        ${xorg.xset}/bin/xset dpms 300
        ${volumeicon}/bin/volumeicon &
        ${parcellite}/bin/parcellite &
        ${solaar}/bin/solaar -w hide &
      '';
    };
  };

  programs.slock.enable = true;
}

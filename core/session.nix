{ config, pkgs, lib, kbLayout, username, ... }:
let
  fcitx5 = config.i18n.inputMethod.package;
in
{
  environment.systemPackages = with pkgs; [
    rofi
    rofi-rbw
    rofi-vpn
    pinentry-qt
    alacritty
    pavucontrol
    easyeffects
    birdtray
    thunderbird
    qpwgraph
    blueman
    xdg-utils
    playerctl
    arandr
    file-roller
    synology-drive-client
    anydesk
    teamviewer
    goldendict-ng
    wineWow64Packages.stable
    winetricks
    polybar
    xsel
    xdotool
    feh
    sxhkd
    dunst
    libnotify
    pamixer
    caffeine-ng
    picom
    copyq
    pa_applet
  ];

  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  services.upower.enable = true;

  services.teamviewer.enable = true;
  systemd.services.teamviewerd.wantedBy = lib.mkForce [ ];

  programs.nm-applet.enable = true;
  programs.virt-manager.enable = true;

  location = {
    provider = "manual"; #"geoclue2";
    latitude = 21.0;
    longitude = 105.0;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        qt6Packages.fcitx5-unikey
      ];
      waylandFrontend = true;
    };
  };

  services.tumbler.enable = true;
  services.blueman.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };

  services.xserver = {
    enable = true;
    xkb.layout = kbLayout;
    excludePackages = with pkgs; [ xterm ];
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: with hp; [
        dbus
        monad-logger
        xmonad-dbus
      ];
    };

    displayManager.sessionCommands = with pkgs; ''
      ${xset}/bin/xset r rate 200 25
      ${xset}/bin/xset dpms 300
      ${feh}/bin/feh --bg-fill ${./../home/wallpaper}
      ${pa_applet}/bin/pa-applet &
      ${goldendict-ng}/bin/goldendict &
      ${copyq}/bin/copyq &
      ${blueman}/bin/blueman-applet &
      ${fcitx5}/bin/fcitx5 &
      ${birdtray}/bin/birdtray &
      ${synology-drive-client}/bin/synology-drive &
    '';
  };

  programs.slock.enable = true;

  services.redshift = {
    enable = true;
    temperature = {
      day = 5000;
      night = 4000;
    };
  };

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = 0.75;
    inactiveOpacity = 0.99;
    activeOpacity = 1.0;
    backend = "glx";
    settings = {
      focus-exclude = "x = 0 && y = 0 && override_redirect = true";
    };
  };

  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+xmonad";
    autoLogin = {
      enable = true;
      user = username;
    };
  };
}

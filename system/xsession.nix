{ pkgs, lib, username, dpi, ... }:

{
  environment.systemPackages = with pkgs; [
    (rofi.override { plugins = [ rofi-calc rofi-emoji ]; })
    rofi-rbw
    rofi-vpn
    pinentry-gtk2
    polybar
    alacritty
    xsel
    dunst
    libnotify
    pavucontrol
    easyeffects
    qpwgraph
    blueman
    xdg_utils
    slock
    pa_applet
    parcellite
    xdotool
    playerctl
    feh
    sxhkd
    pamixer
    arandr
    anydesk
    teamviewer
    jellyfin-media-player
    caffeine-ng
    goldendict-ng
  ];

  services.teamviewer.enable = true;
  systemd.services.teamviewerd.wantedBy = lib.mkForce [ ];

  programs.nm-applet.enable = true;
  programs.virt-manager.enable = true;

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
    settings = {
      focus-exclude = "x = 0 && y = 0 && override_redirect = true";
    };
  };
  services.tumbler.enable = true;
  services.blueman.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };

  services.displayManager = {
    defaultSession = "none+xmonad";
    autoLogin.enable = true;
    autoLogin.user = username;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
    };
    inherit dpi;

    excludePackages = with pkgs; [
      xterm
    ];

   windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: with hp; [
        dbus
        monad-logger
      ];
    };

    xautolock = {
      enable = true;
      locker = "/run/wrappers/bin/slock";
      time = 5;
      extraOptions = [ "-detectsleep" "-corners '----'" ];
    };

    displayManager = {
      lightdm = {
        enable = true;
      };

      sessionCommands = with pkgs; ''
        ${xorg.xset}/bin/xset r rate 200 25
        ${xorg.xset}/bin/xset dpms 300
        ${pa_applet}/bin/pa-applet &
        ${parcellite}/bin/parcellite &
        ${goldendict-ng}/bin/goldendict &
      '';
    };
  };

  programs.slock.enable = true;
}

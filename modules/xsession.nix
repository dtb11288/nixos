{ pkgs, config, lib, username, dpi, kbLayout, ... }:
let
  fcitx5 = config.i18n.inputMethod.package;
in
{
  environment.systemPackages = with pkgs; [
    rofi
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
    xdg-utils
    pa_applet
    copyq
    xdotool
    playerctl
    feh
    sxhkd
    pamixer
    arandr
    anydesk
    teamviewer
    caffeine-ng
    goldendict-ng
    appimage-run
    wineWowPackages.stable
    winetricks
  ];

  programs.slock.enable = true;
  programs.appimage.binfmt = true;
  programs.xfconf.enable = true;
  programs.file-roller.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

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
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-unikey
    ];
  };

  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.99;
    backend = "xrender";
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
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  xdg.portal = {
    enable = true;
    config = {
      common.default = "gtk";
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      libsForQt5.xdg-desktop-portal-kde
      kdePackages.xdg-desktop-portal-kde
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
      layout = kbLayout;
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
        xmonad-dbus
      ];
    };

    xautolock = {
      enable = true;
      locker = "${pkgs.common.locker}";
      time = 5;
      extraOptions = [ "-detectsleep" "-corners '----'" ];
    };

    desktopManager.runXdgAutostartIfNone = false;
    displayManager = {
      lightdm = {
        enable = true;
      };

      sessionCommands = with pkgs; ''
        ${xorg.xset}/bin/xset r rate 200 25
        ${xorg.xset}/bin/xset dpms 300
        ${pa_applet}/bin/pa-applet &
        ${copyq}/bin/copyq &
        ${blueman}/bin/blueman-applet &
        ${fcitx5}/bin/fcitx5 &
        ${birdtray}/bin/birdtray &
        ${flatpak}/bin/flatpak run com.synology.SynologyDrive &
        ${goldendict-ng}/bin/goldendict &
      '';
    };
  };
}

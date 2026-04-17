{ pkgs, lib, system, inputs, username, ... }:
# let
#   fcitx5 = config.i18n.inputMethod.package;
# in
{
  environment.systemPackages = with pkgs; [
    rofi
    rofi-rbw
    rofi-vpn
    pinentry-qt
    polybar
    foot
    xsel
    dunst
    libnotify
    pavucontrol
    easyeffects
    flameshot
    birdtray
    thunderbird
    qpwgraph
    blueman
    xdg-utils
    pa_applet
    copyq
    wtype
    playerctl
    feh
    sxhkd
    pamixer
    arandr
    file-roller
    synology-drive-client
    anydesk
    teamviewer
    caffeine-ng
    goldendict-ng
    wineWow64Packages.stable
    winetricks
  ];

  programs.mango.enable = true;

  programs.dms-shell = {
    enable = true;

    package = inputs.dms.packages.${system}.default;
    quickshell.package = inputs.quickshell.packages.${system}.quickshell;

    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableClipboardPaste = true;       # Pasting from the clipboard history (wtype)
  };

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
      xdg-desktop-portal-wlr
    ];
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "mango";
    autoLogin = {
      enable = true;
      user = username;
    };
  };

  # services.xserver = {
  #   enable = true;
  #   xkb = {
  #     layout = kbLayout;
  #   };
  #   inherit dpi;
  #
  #   excludePackages = with pkgs; [
  #     xterm
  #   ];
  #
  #   windowManager.xmonad = {
  #     enable = true;
  #     enableContribAndExtras = true;
  #     extraPackages = hp: with hp; [
  #       dbus
  #       xmonad-dbus
  #     ];
  #   };
  #
  #   xautolock = {
  #     enable = true;
  #     locker = "${pkgs.common.locker}";
  #     time = 5;
  #     extraOptions = [ "-detectsleep" "-corners '----'" ];
  #   };
  #
  #   desktopManager.runXdgAutostartIfNone = false;
  #   displayManager = {
  #     lightdm.enable = true;
  #     sessionCommands = with pkgs; ''
  #       ${caffeine-ng}/bin/caffeine &
  #       ${xset}/bin/xset r rate 200 25
  #       ${xset}/bin/xset dpms 300
  #       ${pa_applet}/bin/pa-applet &
  #       ${copyq}/bin/copyq &
  #       ${blueman}/bin/blueman-applet &
  #       ${fcitx5}/bin/fcitx5 &
  #       ${birdtray}/bin/birdtray &
  #       ${synology-drive-client}/bin/synology-drive &
  #       ${goldendict-ng}/bin/goldendict &
  #     '';
  #   };
  # };
}

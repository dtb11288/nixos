{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi
    rofi-rbw
    pinentry-gtk2
    polybar
    alacritty
    xss-lock
    xautolock
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
    caffeine-ng
    pamixer
  ];

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];
  };
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

  services.picom.enable = true;
  services.tumbler.enable = true;

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.slock}/bin/slock";
  };

  services.blueman.enable = true;

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
      locker = "${pkgs.slock}/bin/slock";
      extraOptions = [ "-detectsleep" ];
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
        ${caffeine-ng}/bin/caffeine &
        ${flatpak}/bin/flatpak run com.synology.SynologyDrive &
      '';
    };
  };

  programs.slock.enable = true;
}

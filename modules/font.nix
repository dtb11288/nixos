{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
    nerd-fonts.noto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    freefont_ttf
    corefonts
    dejavu_fonts
    liberation_ttf
    siji
  ];

  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = config.fonts.packages ++ (with pkgs; [
          adwaita-icon-theme
        ]);
        pathsToLink = [ "/share/fonts" "/share/icons" ];
    };
  in {
    "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
  };
}

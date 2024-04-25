{ config, pkgs, ... }:

{
  # Select internationalisation properties.
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" "Noto" ]; })
    noto-fonts
    noto-fonts-cjk
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
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
}

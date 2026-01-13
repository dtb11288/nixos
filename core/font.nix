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
    noto-fonts-color-emoji
    freefont_ttf
    corefonts
    dejavu_fonts
    liberation_ttf
    siji
  ];

  # system.fsPackages = [ pkgs.bindfs ];
  # fileSystems = let
  #   mkRoSymBind = path: {
  #     device = path;
  #     fsType = "fuse.bindfs";
  #     options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  #   };
  #   aggregatedIcons = pkgs.buildEnv {
  #     name = "system-icons";
  #     paths = with pkgs; [
  #       adwaita-icon-theme
  #     ];
  #     pathsToLink = [ "/share/icons" ];
  #   };
  #   aggregatedFonts = pkgs.buildEnv {
  #     name = "system-fonts";
  #     paths = config.fonts.packages;
  #     pathsToLink = [ "/share/fonts" ];
  #   };
  # in {
  #   "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
  #   "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  # };
}

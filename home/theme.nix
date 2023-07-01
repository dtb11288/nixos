{ pkgs, lib, theme, ... }: {

  home.pointerCursor = {
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 32;
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      scaling-factor = lib.hm.gvariant.mkUint32 2;
    };
  };

  xresources.extraConfig = with theme.colors; ''
    *background: ${background}
    *foreground: ${foreground}
    *color0: ${color0}
    *color1: ${color1}
    *color2: ${color2}
    *color3: ${color3}
    *color4: ${color4}
    *color5: ${color5}
    *color6: ${color6}
    *color7: ${color7}
    *color8: ${color8}
    *color9: ${color9}
    *color10: ${color10}
    *color11: ${color11}
    *color12: ${color12}
    *color13: ${color13}
    *color14: ${color14}
    *color15: ${color15}
  '';

  home.sessionVariables.GTK_THEME = "Adwaita";
}

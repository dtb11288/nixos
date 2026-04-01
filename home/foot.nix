{ theme, lib, ... }:
let
  stripHash = lib.mapAttrs (name: value:
    if lib.hasPrefix "#" value then
      builtins.substring 1 (builtins.stringLength value) value
    else value
  );
in
{
  programs.foot = {
    enable = true;

    server.enable = true;

    settings = with stripHash theme.colors; {
      main = {
        term = "foot";
        font = "SauceCodePro Nerd Font Mono:size=12";
      };

      mouse = {
        hide-when-typing = true;
      };

      colors-dark = {
        foreground = foreground;
        background = background;
        selection-foreground = background;
        selection-background = foreground;
        cursor = "${background} ${foreground}";

        regular0 = color0;
        regular1 = color1;
        regular2 = color2;
        regular3 = color3;
        regular4 = color4;
        regular5 = color5;
        regular6 = color6;
        regular7 = color7;

        bright0 = color8;
        bright1 = color9;
        bright2 = color10;
        bright3 = color11;
        bright4 = color12;
        bright5 = color13;
        bright6 = color14;
        bright7 = color15;
      };
    };
  };
}

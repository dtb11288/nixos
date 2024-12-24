{ pkgs, dpi, dpiRatio, config, theme, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  font = "Noto Front 13";
in
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    inherit font;
    extraConfig = {
      inherit dpi;
      modes = map mkLiteral [ "drun" "run" "calc" "emoji" ];
      show-icons = false;
    };
    theme = with theme.colors; {
      "*" = {
        inherit font;

        bg0 = mkLiteral "${color15}";
        bg1 = mkLiteral "${color7}";
        bg2 = mkLiteral "${color2}";

        fg0 = mkLiteral "${background}";
        fg1 = mkLiteral "${color0}";
        fg2 = mkLiteral "${foreground}";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";

        margin = 0;
        padding = 0;
        spacing = 0;
      };

      window = {
        background-color = mkLiteral "@bg0";
        location = mkLiteral "center";
        width = 1000 * dpiRatio;
        border-radius = 4 * dpiRatio;
      };

      inputbar = {
        inherit font;
        padding = mkLiteral "${toString (13 * dpiRatio)}px";
        spacing = mkLiteral "${toString (13 * dpiRatio)}px";
        children = map mkLiteral [ "icon-search" "entry" ];
      };

      "icon-search" = {
        expand = false;
        filename = "search";
        size = mkLiteral "${toString (2 * dpiRatio)}px";
      };

      "icon-search, entry, element-icon, element-text" = {
        vertical-align = mkLiteral "0.5";
      };

      entry = {
        font = mkLiteral "inherit";
        placeholder = "Search";
        placeholder-color = mkLiteral "@fg2";
      };

      message = {
        border = mkLiteral "2px 0 0";
        border-color = mkLiteral "@bg1";
        background-color = mkLiteral "@bg1";
      };

      textbox = {
        padding = mkLiteral "6px 24px";
      };

      listview = {
        lines = 10;
        columns = 1;

        fixed-height = true;
        border = mkLiteral "1px 0 0";
        border-color = mkLiteral "@bg1";
      };

      element = {
        padding = mkLiteral "${toString (4 * dpiRatio)}px ${toString (14 * dpiRatio)}px";
        spacing = mkLiteral "${toString (16 * dpiRatio)}px";
        background-color = mkLiteral "transparent";
      };

      "element normal active" = {
        text-color = mkLiteral "@bg2";
      };

      "element selected normal, element selected active" = {
        background-color = mkLiteral "@bg2";
        text-color = mkLiteral "@fg1";
      };

      element-icon = {
        size = mkLiteral "1em";
      };

      element-text = {
        text-color = mkLiteral "inherit";
      };
    };
  };
}

{ theme, factor, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font = {
        normal = {
          familly = "SauceCodePro Nerd Font Mono,SauceCodePro NFM";
          style = "Regular";
        };
        bold = {
          familly = "SauceCodePro Nerd Font Mono,SauceCodePro NFM";
          style = "Bold";
        };
        italic = {
          familly = "SauceCodePro Nerd Font Mono,SauceCodePro NFM";
          style = "Italic";
        };
        bold_italic = {
          familly = "SauceCodePro Nerd Font Mono,SauceCodePro NFM";
          style = "Bold Italic";
        };
        size = 11.0 * factor;
      };
      colors = with theme.colors; {
        primary = {
          background = background;
          foreground = foreground;
        };

        cursor = {
          text = background;
          cursor = foreground;
        };

        normal = {
          black = color0;
          red = color1;
          green = color2;
          yellow = color3;
          blue = color4;
          magenta = color5;
          cyan = color6;
          white = color7;
        };

        bright = {
          black = color8;
          red = color9;
          green = color10;
          yellow = color11;
          blue = color12;
          magenta = color13;
          cyan = color14;
          white = color15;
        };
      };
    };
  };
}

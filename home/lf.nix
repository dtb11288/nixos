{ ... }:
let
  icons = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
    sha256 = "sha256:0141nzyjr3mybkbn9p0wwv5l0d0scdc2r7pl8s1lgh11wi2l771x";
  };
  colors = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/colors.example";
    sha256 = "sha256:1ri9d5hdmb118sqzx0sd22fbcqjhgrp3r9xcsm88pfk3wig6b0ki";
  };
in
{
  programs.lf = {
    enable = true;
    settings = {
      hidden = true;
      ignorecase = true;
      icons = true;
      shell = "zsh";
      drawbox = true;
    };
    keybindings = {
      a = "push :mkdir<space>";
      A = "push :mkfile<space>";
    };
    commands = {
      mkfile = ''
        ''${{
          touch "$@"
          nvim -p "$@"
        }}
      '';
      mkdir = ''
        %mkdir -p "$@"
      '';
      extract = ''
        ''${{
          set -f
          case $f in
              *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
              *.tar.gz|*.tgz) tar xzvf $f;;
              *.tar.xz|*.txz) tar xJvf $f;;
              *.zip) unzip $f;;
              *.rar) unrar x $f;;
              *.7z) 7z x $f;;
          esac
        }}
      '';
      tar = ''
        ''${{
          set -f
          mkdir $1
          cp -r $fx $1
          tar czf $1.tar.gz $1
          rm -rf $1
        }}
      '';
      zip = ''
        ''${{
          set -f
          mkdir $1
          cp -r $fx $1
          zip -r $1.zip $1
          rm -rf $1
        }}
      '';
    };
  };
  xdg.configFile."lf/icons".source = icons;
  xdg.configFile."lf/colors".source = colors;
}

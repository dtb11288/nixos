{ pkgs, theme, lib, config, ... }:
{
  xdg.configFile."nvim" = {
    source = pkgs.symlinkJoin {
      name = "nvim-config";
      paths = [
        (lib.cleanSourceWith {
          src = ./config;

          # Filter to exclude certain files and directories
          filter = name: type:
            !(lib.hasSuffix "lua/variables.lua" name);
        })
      ];
    };
    recursive = true;
  };
  xdg.configFile."nvim/lua/variables.lua".source = pkgs.replaceVars ./config/lua/variables.lua ({
    vim_home = "${config.xdg.configHome}/nvim";
    nodejs = "${pkgs.nodejs}/bin/node";
  } // theme.colors);
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}

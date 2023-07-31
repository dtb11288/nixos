{ theme, lib, config, ... }:
let
  colors = lib.attrsets.mapAttrsToList (name: value: "${lib.strings.toUpper name} = \"${value}\"") theme.colors;
  luaColors = builtins.concatStringsSep "\n" colors;
in
{
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."nvim/lua/variables.lua".text = ''
    VIM_HOME = vim.fn.expand("${config.xdg.configHome}/nvim")
    BORDER = {
      { "╔", "CmpBorder" },
      { "═", "CmpBorder" },
      { "╗", "CmpBorder" },
      { "║", "CmpBorder" },
      { "╝", "CmpBorder" },
      { "═", "CmpBorder" },
      { "╚", "CmpBorder" },
      { "║", "CmpBorder" },
    }
    ${luaColors};
  '';
  xdg.configFile."nvim/init.lua".text = ''
    require("variables")
    require("settings")
    require("plugins")
    require("configs")
  '';
}

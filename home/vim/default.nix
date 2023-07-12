{ ... }:
{
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
  xdg.configFile."nvim/snippets" = {
    source = ./snippets;
    recursive = true;
  };
  xdg.configFile."nvim/init.lua".source = ./init.lua;
}

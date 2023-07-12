{ ... }:
{
  xdg.configFile."leftwm" = {
    source = ./config;
    recursive = true;
  };
}

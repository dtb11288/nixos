{ pkgs, lib, theme, ... }:
let
  stripHash = lib.mapAttrs (name: value:
    if lib.hasPrefix "#" value then
      builtins.substring 1 (builtins.stringLength value) value
    else value
  );
in
{
  xdg.configFile."mango/config.conf".source = pkgs.replaceVars ./config.conf ({
  } // stripHash theme.colors);
}

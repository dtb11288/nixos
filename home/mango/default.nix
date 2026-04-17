{ pkgs, lib, theme, ... }:
let
  stripHash = lib.mapAttrs (name: value:
    if lib.hasPrefix "#" value then
      builtins.substring 1 (builtins.stringLength value) value
    else value
  );
in
{
  xdg.configFile."mango/config" = {
    source = pkgs.symlinkJoin {
      name = "mango-config";
      paths = [
        (lib.cleanSourceWith {
          src = ./config;

          # Filter to exclude certain files and directories
          filter = name: type:
            !(lib.hasSuffix "theme.conf" name);
        })
      ];
    };
    recursive = true;
  };
  xdg.configFile."mango/config.conf".source = ./config.conf;
  xdg.configFile."mango/config/theme.conf".source = pkgs.replaceVars ./config/theme.conf ({
  } // stripHash theme.colors);
}

{ pkgs, ... }:
let
  telegram = pkgs.writeShellScriptBin "telegram-desktop" ''
    export QT_SCALE_FACTOR=1.5; exec ${pkgs.telegram-desktop}/bin/telegram-desktop
  '';
in {
  home.packages = [ telegram ];
}

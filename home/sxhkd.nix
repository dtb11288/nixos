{ pkgs, hostname, ... }:
let
  keybindings = import ./sxhkd-${hostname}.nix pkgs;
in
{
  services.sxhkd = {
    enable = true;
    keybindings = with pkgs; keybindings // {
      "mod4 + p" = "rofi -show run";
      "mod4 + e" = "rofi -show emoji";
      "mod4 + c" = "rofi -show calc -calc-command '${pkgs.xdotool}/bin/xdotool type --clearmodifiers {result}'";
      "mod4 + s" = "${rofi-rbw}/bin/rofi-rbw";
    };
  };
}

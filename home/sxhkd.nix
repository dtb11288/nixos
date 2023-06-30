{ pkgs, hostname, ... }:
let
  keybindings = import ./sxhkd-${hostname}.nix pkgs;
in
{
  services.sxhkd = {
    enable = true;
    keybindings = with pkgs; keybindings // {
      "super + p" = "rofi -show run";
      "super + e" = "rofi -show emoji";
      "super + c" = "rofi -show calc -calc-command 'xdotool type --clearmodifiers \"{expression} = {result}\"'";
      "super + s" = "${rofi-rbw}/bin/rofi-rbw";
    };
  };
}

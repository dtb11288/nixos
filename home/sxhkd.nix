{ pkgs, hostname, ... }:
let
  keybindings = import ./sxhkd-${hostname}.nix pkgs;
in
{
  services.sxhkd = {
    enable = true;
    keybindings = with pkgs; keybindings // {
      XF86AudioRaiseVolume = "${pkgs.pamixer}/bin/pamixer -u -i 5";
      XF86AudioLowerVolume = "${pkgs.pamixer}/bin/pamixer -d 5";
      XF86AudioMute = "${pkgs.pamixer}/bin/pamixer -t";
      XF86AudioPrev = "${pkgs.playerctl}/bin/playerctl previous";
      XF86AudioNext = "${pkgs.playerctl}/bin/playerctl next";
      XF86AudioPlay = "${pkgs.playerctl}/bin/playerctl play-pause";
      "mod4 + p" = "rofi -show run";
      "mod4 + e" = "rofi -show emoji";
      "mod4 + c" = "rofi -show calc -calc-command '${pkgs.xsel}/bin/xsel -b'";
      "mod4 + s" = "${rofi-rbw}/bin/rofi-rbw";
      "mod4 + shift + Return" = "${alacritty}/bin/alacritty";
      "mod4 + Escape" = "slock";
    };
  };
}
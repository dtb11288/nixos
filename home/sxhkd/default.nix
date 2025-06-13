{ pkgs, hostname, ... }:
let
  keybindings = import ./sxhkd-${hostname}.nix { inherit pkgs; };
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
      "mod4 + p" = "${rofi}/bin/rofi -show run";
      "mod4 + e" = "${rofi}/bin/rofi -show emoji";
      "mod4 + c" = "${rofi}/bin/rofi -show calc -no-show-match -no-sort -calc-command \"echo -n '\\\{result\\\}' | xsel -b\"";
      "mod4 + s" = "${rofi-rbw}/bin/rofi-rbw";
      "mod4 + v" = "${rofi-vpn}/bin/rofi-vpn";
      "mod4 + d" = "${rofi-systemd}/bin/rofi-systemd";
      "mod4 + Escape" = "${pkgs.common.locker}";
      "mod4 + shift + Return" = "${pkgs.common.terminal}";
    };
  };
}

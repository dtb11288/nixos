{ pkgs, ... }:
{
  # Raises volume
  XF86AudioRaiseVolume = "${pkgs.pamixer}/bin/pamixer -u -i 5";

  # Lowers volume
  XF86AudioLowerVolume = "${pkgs.pamixer}/bin/pamixer -d 5";

  # Mute
  XF86AudioMute = "${pkgs.pamixer}/bin/pamixer -t";

  # Audio previeous
  XF86AudioPrev = "${pkgs.playerctl}/bin/playerctl previous";

  # Audio next
  XF86AudioNext = "${pkgs.playerctl}/bin/playerctl next";

  # Audio play
  XF86AudioPlay = "${pkgs.playerctl}/bin/playerctl play-pause";

  # Brightness up
  XF86MonBrightnessUp = "${pkgs.ddcutil}/bin/ddcutil setvcp 10 + 10";

  # Brightness down
  XF86MonBrightnessDown = "${pkgs.ddcutil}/bin/ddcutil setvcp 10 - 10";
}

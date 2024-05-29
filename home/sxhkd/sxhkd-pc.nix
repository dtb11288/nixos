{ pkgs, ... }:
{
  # Brightness up
  XF86MonBrightnessUp = "${pkgs.ddcutil}/bin/ddcutil setvcp 10 + 10";

  # Brightness down
  XF86MonBrightnessDown = "${pkgs.ddcutil}/bin/ddcutil setvcp 10 - 10";
}

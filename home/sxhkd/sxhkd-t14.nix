{ pkgs, ... }:
{
  # Brightness up
  XF86MonBrightnessUp = "${pkgs.brightnessctl}/bin/brightnessctl s 5%-";

  # Brightness down
  XF86MonBrightnessDown = "${pkgs.brightnessctl}/bin/brightnessctl s +5%";
}

{ pkgs, ... }:
{
  # Brightness up
  XF86MonBrightnessUp = "${pkgs.light}/bin/light -A 5";

  # Brightness down
  XF86MonBrightnessDown = "${pkgs.light}/bin/light -U 5";
}

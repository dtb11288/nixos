{ pkgs, hostname, ... }:
let
  keybindings = import ./sxhkd-${hostname}.nix pkgs;
in
{
  services.sxhkd = {
    enable = true;
    inherit keybindings;
  };
}

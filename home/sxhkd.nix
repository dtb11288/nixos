{ hostname, ... }:
let
  keybindings = import ./sxhkd-${hostname}.nix;
in
{
  services.sxhkd = {
    enable = true;
    inherit keybindings;
  };
}

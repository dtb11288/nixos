{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bruno
    opencode
  ];
}

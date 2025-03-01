{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    ryujinx
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}

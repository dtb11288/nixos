{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    ryubing
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}

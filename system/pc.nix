{ pkgs, lib, config, username, ... }:
let
  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    # NUM_DEVICES=$(${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    # for i in $(seq 0 $(($NUM_DEVICES - 1))); do
    for i in $(seq 0 4); do
      ${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
    done
  '';
in
{
  imports = [
    ./configuration.nix
    ./hardware-pc.nix
  ];

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiVdpau
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
    ];

  services.xserver.videoDrivers = ["nvidia"];
  services.thermald.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs; [
    no-rgb
    ddcutil
    openrgb-with-all-plugins
  ];

  services.udev.packages = [ pkgs.openrgb-with-all-plugins ];

  hardware.i2c.enable = true;
  users.extraUsers.${username} = {
    extraGroups = [ "i2c" ];
  };
}

{ pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-t14.nix
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.libinput-gestures}/bin/libinput-gestures &
    ${pkgs.cbatticon}/bin/cbatticon &
  '';
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.disableWhileTyping = true;
  };
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  environment.systemPackages = with pkgs; [
    cbatticon
    libinput-gestures
    radeontop
  ];

  # This will detech systemd event like when you close the lid
  programs.xss-lock = {
    enable = true;
    lockerCommand = "/run/wrappers/bin/slock";
  };
}

{ pkgs, ... }:
{
  imports = [
    ../../modules/game.nix
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver.deviceSection = ''Option "TearFree" "true"''; # For amdgpu.

  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.libinput-gestures}/bin/libinput-gestures &
    ${pkgs.cbatticon}/bin/cbatticon &
  '';
  services.libinput = {
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

  security.pam.services.sudo.rules.auth.unix.order = 11200;

  environment.systemPackages = with pkgs; [
    cbatticon
    libinput-gestures
    amdgpu_top
  ];

  programs.light.enable = true;

  # This will detech systemd event like when you close the lid
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.common.locker}";
  };
}

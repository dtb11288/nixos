{ pkgs, ... }:
{
  imports = [];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      vaapiVdpau
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.libinput-gestures}/bin/libinput-gestures &
    ${pkgs.cbatticon}/bin/cbatticon &
  '';
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.disableWhileTyping = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    open = false;
    prime = {
      # sync.enable = true;

      offload.enable = true;
      offload.enableOffloadCmd = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    cbatticon
    libinput-gestures
  ];

  # This will detech systemd event like when you close the lid
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.common.locker}";
  };

  programs.light.enable = true;

  console.font = "sun12x22";
}

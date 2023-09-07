{ inputs, lib, config, pkgs, hostname, ... }: {
  imports = [
    ./user.nix
    ./font.nix
    ./xsession.nix
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    package = pkgs.nixFlakes;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Use the EFI boot loader.
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      configurationLimit = 5;
      enable = true;
    };
  };
  boot.supportedFilesystems = [ "ntfs" ];

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    rbw
    pinentry
    bind
    git
    neovim
    silver-searcher
    ripgrep
    file
    coreutils
    zellij
    htop
    btop
    wget
    curl
    git
    alsaUtils
    fzf
    lazygit
    direnv
    lazydocker
    lf
    lshw
    lm_sensors
    pciutils
    zip
    unzip
    unrar
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings.PermitRootLogin = "no";
  };
  services.printing.enable = true;
  services.ntp.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  networking = {
    hostName = "${hostname}";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    extraHosts = ''
      127.0.0.1  biits.lambda
    '';
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = true;
      insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
  };

  services.blueman.enable = true;
  services.tlp.enable = true;
  services.thermald.enable = true;
  services.gvfs.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  nix.settings.max-jobs = lib.mkDefault 8;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

{ inputs, lib, config, pkgs, hostname, secrets, ... }: {
  imports = [
    ./user.nix
    ./font.nix
    ./xsession.nix
    ./8bitdo.nix
    ./qudelix.nix
  ];

  hardware.enableAllFirmware = true;

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
  boot.supportedFilesystems = [ "ntfs" "btrfs" "exfat" ];

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
    alsaUtils
    nfs-utils
    fzf
    lazygit
    direnv
    lazydocker
    lf
    lshw
    lm_sensors
    pciutils
    tree
    zip
    unzip
    unrar
    docker-compose
    usbutils
    tmux
    glib
    git-crypt
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = true;
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
    firewall.enable = false;
  };

  services.resolved = {
    enable = true;
    llmnr = "false";
    dnsovertls = "true";
    extraConfig = ''
      DNS=45.90.28.0#${secrets.nextdns.domain}
      DNS=2a07:a8c0::#${secrets.nextdns.domain}
      DNS=45.90.30.0#${secrets.nextdns.domain}
      DNS=2a07:a8c1::#${secrets.nextdns.domain}
    '';
  };

  services.blueman.enable = true;
  services.tlp.enable = true;
  services.gvfs.enable = true;
  programs.adb.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  nix.settings.max-jobs = lib.mkDefault 8;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

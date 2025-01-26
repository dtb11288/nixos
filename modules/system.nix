{ lib, pkgs, hostname, secrets, programs-sqlite-db, ... }: {
  imports = [];

  hardware.enableAllFirmware = true;

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
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
    wget
    curl
    alsa-utils
    nfs-utils
    fzf
    lazygit
    direnv
    lazydocker
    yazi
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
    termscp
    ventoy-full
    dua
    bandwhich
    slumber
  ];

  # Direnv support
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/docker";
    };
  };
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
      DNS=45.90.28.0#${secrets.nextdns.id}.dns.nextdns.io
      DNS=2a07:a8c0::#${secrets.nextdns.id}.dns.nextdns.io
      DNS=45.90.30.0#${secrets.nextdns.id}.dns.nextdns.io
      DNS=2a07:a8c1::#${secrets.nextdns.id}.dns.nextdns.io
    '';
  };

  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
         governor = "powersave";
         turbo = "never";
      };
      charger = {
         governor = "performance";
         turbo = "auto";
      };
    };
  };

  environment.variables = {
    PATH = "/var/lib/flatpak/exports/bin:$PATH";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.adb.enable = true;
  programs.command-not-found.dbPath = programs-sqlite-db;
  programs.zsh.enable = true;
  programs.ssh.startAgent = true;

  nix.settings.max-jobs = lib.mkDefault 8;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

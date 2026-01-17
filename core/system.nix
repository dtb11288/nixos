{ pkgs, bootPath, hostname, secrets, programs-sqlite-db, theme, ... }: {

  imports = [
    # ../moduels/nordvpn.nix
    ../modules/uutils.nix
    ../modules/qudelix.nix
  ];

  hardware.enableAllFirmware = true;

  # Use the EFI boot loader.
  boot.loader = {
    efi = {
      efiSysMountPoint = bootPath;
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
    bind
    git
    neovim
    silver-searcher
    ripgrep
    file
    uutils-coreutils
    zellij
    killall
    btop
    wget
    curl
    aria2
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
    p7zip
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
    appimage-run
    nix-tree
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.10"
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
    nameservers = [
      "45.90.28.0#${secrets.nextdns.id}.dns.nextdns.io"
      "2a07:a8c0::#${secrets.nextdns.id}.dns.nextdns.io"
      "45.90.30.0#${secrets.nextdns.id}.dns.nextdns.io"
      "2a07:a8c1::#${secrets.nextdns.id}.dns.nextdns.io"
    ];
  };

  services.resolved = {
    enable = true;
    llmnr = "false";
    dnsovertls = "true";
  };

  # services.custom.nordvpn.enable = true;
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
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  environment.variables = with theme.colors;{
    PATH = "/var/lib/flatpak/exports/bin:$PATH";
    EDITOR = "nvim";
    VISUAL = "nvim";

    BACKGROUND = background;
    FOREGROUND = foreground;
    COLOR0 = color0;
    COLOR1 = color1;
    COLOR2 = color2;
    COLOR3 = color3;
    COLOR4 = color4;
    COLOR5 = color5;
    COLOR6 = color6;
    COLOR7 = color7;
    COLOR8 = color8;
    COLOR9 = color9;
    COLOR10 = color10;
    COLOR11 = color11;
    COLOR12 = color12;
    COLOR13 = color13;
    COLOR14 = color14;
    COLOR15 = color15;
  };

  programs.command-not-found.dbPath = programs-sqlite-db;
  programs.zsh.enable = true;
  programs.ssh.startAgent = true;
  programs.appimage.binfmt = true;
}

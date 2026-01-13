{ inputs, lib, config, pkgs, stateVersion, ... }: {

  imports = lib.pipe ./core [
    (builtins.readDir)
    (builtins.attrNames)
    (builtins.filter (name: builtins.match ".*\\.nix" name != null))
    (map (name: ./core/${name}))
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    package = pkgs.nixVersions.stable;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      max-jobs = lib.mkDefault 8;
      download-buffer-size = 512 * 1024 * 1024; # 500MB
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = stateVersion;
}

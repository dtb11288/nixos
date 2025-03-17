final: prev: {
  # can be removed when https://github.com/NixOS/nixpkgs/pull/389711 is merged
  libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ prev.nss ];
  });
}

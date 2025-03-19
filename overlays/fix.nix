final: prev: {
  libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ prev.nss ];
  });
}

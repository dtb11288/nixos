final: prev: {
  polybar = prev.polybar.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (prev.fetchpatch {
        name = "gcc15-cstdint-fix.patch";
        url = "https://github.com/polybar/polybar/commit/f99e0b1c7a5b094f5a04b14101899d0cb4ece69d.patch";
        sha256 = "sha256-Mf9R4u1Kq4yqLqTFD5ZoLjrK+GmlvtSsEyRFRCiQ72U=";
      })
    ];
  });
}

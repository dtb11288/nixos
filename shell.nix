{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixd
    lua-language-server
    haskell-language-server
    (haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [
      xmonad-extras
      xmonad-contrib
      xmonad
      dbus
      xmonad-dbus
    ]))
  ];
}

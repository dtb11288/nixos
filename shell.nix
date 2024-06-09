{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nil
    lua-language-server
    haskell-language-server
    (haskellPackages.ghcWithPackages (hpkgs: [
      hpkgs.xmonad-contrib
      hpkgs.xmonad
      hpkgs.dbus
    ]))
  ];
}

final: prev: {
  common = {
    locker = "/run/wrappers/bin/slock";
    terminal = "${prev.foot}/bin/foot";
  };
  lsp-env = prev.symlinkJoin {
    name = "lsp-env";
    paths = [
      prev.rust-analyzer
      prev.stdenv.cc
      prev.cargo
      prev.rustc

      prev.nixd
      prev.typescript-language-server
      prev.vscode-langservers-extracted
    ];
  };
}

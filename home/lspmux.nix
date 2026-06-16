{ pkgs, ... }:
let
  lspmux-env = pkgs.symlinkJoin {
    name = "lspmux-env";
    paths = [
      pkgs.rust-analyzer
      pkgs.stdenv.cc
      pkgs.cargo
      pkgs.rustc
    ];
  };
in {
  systemd.user.services.lspmux = {
    Unit = {
      Description = "Language server multiplexer server";
    };
    Service = {
      ExecStart = "${pkgs.lspmux}/bin/lspmux server";
      ExecSearchPath = "${lspmux-env}/bin";
      Environment = [
        "RUST_SRC_PATH=${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}"
      ];
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

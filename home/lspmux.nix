{ pkgs, ... }:
{
  systemd.user.services.lspmux = {
    Unit = {
      Description = "Language server multiplexer server";
    };
    Service = {
      ExecStart = "${pkgs.lspmux}/bin/lspmux server";
      ExecSearchPath = "${pkgs.lsp-env}/bin";
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

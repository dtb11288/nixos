{ config, secrets, pkgs, ... }:
{
  programs.aria2 = {
    enable = true;
    settings = {
      continue = true;
      enable-rpc = true;
      enable-http-pipelining = true;
      rpc-secret = secrets.aria2.secret;
      rpc-listen-port = 6800;
      save-session = "${config.xdg.configHome}/aria2/aria2.session";
    };
  };

  systemd.user.services.aria2 = {
    Unit = {
      Description = "Aria2 daemon service";
    };
    Service = {
      ExecStart = "${pkgs.aria2}/bin/aria2c";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

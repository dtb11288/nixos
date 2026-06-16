{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      model = "opencode-go/deepseek-v4-flash";
      formatter = true;
      lsp = true;
      server = {
        port = 4096;
        hostname = "127.0.0.1";
      };
    };
    tui = {
      theme = "system";
      attention = {
        enabled = true;
        notifications = true;
        sound = true;
        volume = 0.4;
        sound_pack = "opencode.default";
      };
    };
  };

  systemd.user.services.opencode = {
    Unit = {
      Description = "OpenCode AI coding agent server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.opencode}/bin/opencode serve";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

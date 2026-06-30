{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      formatter = true;
      lsp = {
        "rust-lspmux" = {
          command = [ "${pkgs.lspmux}/bin/lspmux" ];
          extensions = [ ".rs" ];
        };
      };
      mcp = {
        nixos = {
          type = "local";
          command = ["${pkgs.mcp-nixos}/bin/mcp-nixos"];
          enabled = true;
        };
      };
    };
    tui = {
      theme = "system";
      plugin = ["opencode-subagent-statusline" "@tarquinen/opencode-dcp"];
      attention = {
        enabled = true;
        notifications = true;
        sound = true;
        volume = 0.4;
        sound_pack = "opencode.default";
      };
    };
  };
}

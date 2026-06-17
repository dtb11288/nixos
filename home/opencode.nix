{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      model = "opencode-go/deepseek-v4-flash";
      formatter = true;
      lsp = {
        "rust-lspmux" = {
          command = [ "${pkgs.lspmux}/bin/lspmux" ];
          extensions = [ ".rs" ];
        };
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
}

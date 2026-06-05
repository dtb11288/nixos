{  ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      model = "opencode-go/deepseek-v4-flash";
      formatter = true;
      lsp = true;
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

{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn";
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "hint";
        };
        line-number = "relative";
        mouse = false;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        soft-wrap = {
          enable = true;
        };
        lsp = {
          display-inlay-hints = true;
        };
      };
      keys = {
        normal = {
          esc = ["collapse_selection" "keep_primary_selection"];
          C-g = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
        };
      };
    };
  };
}

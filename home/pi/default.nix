{ inputs, pkgs, theme, ... }:
{
  imports = [ inputs.pi-nix.homeModules.default ];

  home.file = {
    ".pi/agent/lsp.json" = {
      text = builtins.toJSON (import ./lsp.nix { inherit pkgs; });
    };
    ".pi/agent/themes/default.json" = {
      text = builtins.toJSON (import ./themes/theme.nix { inherit theme; });
    };
    ".pi/agent/skills" = {
      source = ./skills;
      recursive = true;
    };
    ".pi/agent/prompts" = {
      source = ./prompts;
      recursive = true;
    };
  };

  programs.pi.coding-agent = {
    enable = true;
    settings = {
      theme = "default";
      packages = [
        "npm:pi-mcp-adapter"
        "npm:pi-lsp"
        "npm:pi-subagents"
        "npm:pi-ask-user"
        "npm:pi-web-access"
        "npm:context-mode"
        "npm:@llblab/pi-telegram"
        "npm:pi-vimmode"
        "https://github.com/monotykamary/pi-double-esc@main"
      ];
    };
  };
}

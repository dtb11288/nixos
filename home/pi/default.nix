{ inputs, pkgs, theme, ... }:
{
  imports = [ inputs.pi-nix.homeModules.default ];

  home.file.".pi/agent/lsp.json" = {
    text = builtins.toJSON (import ./lsp.nix { inherit pkgs; });
  };

  home.file.".pi/agent/themes/default.json" = {
    text = builtins.toJSON (import ./theme.nix { inherit theme; });
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
      ];
    };
  };
}

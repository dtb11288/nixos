{ inputs, pkgs, theme, ... }:
{
  imports = [ inputs.pi-nix.homeModules.default ];

  home.file.".pi/agent/lsp.json" = {
    text = builtins.toJSON {
      version = 1;
      servers = [
        {
          id = "rust-analyzer";
          enabled = true;
          include = [ "**/*.rs" ];
          rootMarkers = [ "Cargo.toml" ];
          bin = "${pkgs.lspmux}/bin/lspmux";
          args = [ ];
          cwd = "{root}";
          languageIdByExtension = { ".rs" = "rust"; };
          startupTimeoutMs = 45000;
          diagnosticsWaitMs = 1500;
          initializationOptions = { };
          settings = { };
        }
      ];
    };
  };

  home.file.".pi/agent/themes/vintage-earth.json" = {
    text = builtins.toJSON (import ./themes/vintage-earth.nix { inherit theme; });
  };

  programs.pi.coding-agent = {
    enable = true;
    settings = {
      theme = "vintage-earth";
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

{ pkgs, ... }:
{
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
}

{ ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      color = {
        ui = "auto";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "master";
      };
    };
  };
}

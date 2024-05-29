{ secrets, ... }:
{
  programs.git = {
    enable = true;
    userEmail = secrets.git.email;
    userName = secrets.git.name;
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

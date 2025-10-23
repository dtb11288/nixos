{ secrets, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = secrets.git.email;
        name = secrets.git.name;
      };
      extraConfig = {
        color = {
          ui = "auto";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}

{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = with pkgs; {
      vi = "${neovim}/bin/nvim";
      vim = "${neovim}/bin/nvim";
      ls = "ls -h --color=auto";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "spwhitt/nix-zsh-completions"; }
      ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "wd" "git" "npm" "cp" "docker" "docker-compose" "rust" "history" ];
      theme = "gentoo";
    };
    initContent = ''
      export KEYTIMEOUT=1;
    '';
  };
}

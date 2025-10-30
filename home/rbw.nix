{ secrets, pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = secrets.rbw.email;
      base_url = secrets.rbw.base_url;
      pinentry = pkgs.pinentry-qt;
    };
  };
}

{ secrets, ... }:
{
  programs.irssi = {
    enable = true;
    networks = {
      liberachat = {
        nick = "${secrets.irssi.nick}";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = false;
        };
      };
    };
  };
}

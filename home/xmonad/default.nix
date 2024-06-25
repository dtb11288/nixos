{ pkgs, config, dpi, theme, ... }:
let
  runbar = pkgs.writeShellScriptBin "runbar" ''
    for pid in `pgrep polybar`; do kill $pid; done;
    index=0
    monitors="$(${pkgs.polybar}/bin/polybar -m | ${pkgs.gnused}/bin/sed s/:.*//)"
    for index in "''${!monitors[@]}"
    do
      let indextemp=index+1
      monitor=$(${pkgs.gnused}/bin/sed "$indextemp!d" <<<"$monitors")
      barname="mainbar$index"
      monitor=$monitor offset=$x width=$width ${pkgs.polybar}/bin/polybar -c ${config.xdg.configHome}/xmonad/polybar.ini $barname &> /dev/null &
      let index=indextemp
    done
  '';
in
{
  xdg.configFile."xmonad/xmonad.hs".source = pkgs.substituteAll ({
    src = ./xmonad.hs;

    terminal = "${pkgs.alacritty}/bin/alacritty";
    runbar = "${runbar}/bin/runbar";
    notifysend = "${pkgs.libnotify}/bin/notify-send";
  } // theme.colors);

  xdg.configFile."xmonad/polybar.ini".source = pkgs.substituteAll ({
    src = ./polybar.ini;

    xmonadlog = "${pkgs.haskellPackages.xmonad-dbus}/bin/xmonad-dbus";
    height = "${toString (24 * dpi / 96)}";
    dpi = "${toString dpi}";
    traymaxsize = "${toString (18 * dpi / 96)}";
  } // theme.colors);
}

{ pkgs, config, dpi, theme, ... }:
let
  runbar = with pkgs; writeShellScriptBin "runbar" ''
    for pid in `pgrep polybar`; do kill $pid; done;
    index=0
    monitors="$(${polybar}/bin/polybar -m | ${gnused}/bin/sed s/:.*//)"
    for index in "''${!monitors[@]}"
    do
      let indextemp=index+1
      monitor=$(${gnused}/bin/sed "$indextemp!d" <<<"$monitors")
      barname="mainbar$index"
      monitor=$monitor offset=$x width=$width ${polybar}/bin/polybar -c ${config.xdg.configHome}/xmonad/polybar.ini $barname &> /dev/null &
      let index=indextemp
    done
  '';
in
{
  xdg.configFile."xmonad/xmonad.hs".source = with pkgs; substituteAll ({
    src = ./xmonad.hs;

    terminal = "${alacritty}/bin/alacritty";
    runbar = "${runbar}/bin/runbar";
    notifysend = "${libnotify}/bin/notify-send";
  } // theme.colors);

  xdg.configFile."xmonad/polybar.ini".source = with pkgs; substituteAll ({
    src = ./polybar.ini;

    xmonadlog = "${haskellPackages.xmonad-dbus}/bin/xmonad-dbus";
    height = "${toString (24 * dpi / 96)}";
    dpi = "${toString dpi}";
    traymaxsize = "${toString (18 * dpi / 96)}";
  } // theme.colors);
}

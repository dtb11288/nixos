{ pkgs, config, dpi, dpiRatio, theme, ... }:
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
    runbar = "${runbar}/bin/runbar";
    notifysend = "${pkgs.libnotify}/bin/notify-send";
    tabheight = "${toString (28 * dpiRatio)}";
  } // theme.colors);

  xdg.configFile."xmonad/polybar.ini".source = pkgs.substituteAll ({
    src = ./polybar.ini;
    xmonadlog = "${pkgs.haskellPackages.xmonad-dbus}/bin/xmonad-dbus";
    height = "${toString (24 * dpiRatio)}";
    dpi = "${toString dpi}";
    traymaxsize = "${toString (18 * dpiRatio)}";
  } // theme.colors);
}

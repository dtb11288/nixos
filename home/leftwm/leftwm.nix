{ theme, config, pkgs, ... }:
let
configFolder = "${config.xdg.configHome}/leftwm";
up = with pkgs; writeShellScriptBin "up" ''
  if [ -f "/tmp/leftwm-theme-down" ]; then
    /tmp/leftwm-theme-down
    rm /tmp/leftwm-theme-down
  fi
  ln -s ${down}/bin/down /tmp/leftwm-theme-down

  ${leftwm}/bin/leftwm-command "LoadTheme ${configFolder}/theme.ron"

  index=0
  monitors="$(${polybar}/bin/polybar -m | ${gnused}/bin/sed s/:.*//)"
  ${leftwm}/bin/leftwm-state -q -n -t ${configFolder}/sizes.liquid | ${gnused}/bin/sed -r '/^\s*$/d' | while read -r width x y
  do
    let indextemp=index+1
    monitor=$(${gnused}/bin/sed "$indextemp!d" <<<"$monitors")
    barname="mainbar$index"
    monitor=$monitor offset=$x width=$width ${polybar}/bin/polybar -c ${configFolder}/polybar.config $barname &> /dev/null &
    let index=indextemp
  done
'';
down = with pkgs; writeShellScriptBin "down" ''
  ${leftwm}/bin/leftwm-command "UnloadTheme"
  ${procps}/bin/pkill polybar
'';
in
{
  xdg.configFile."leftwm/up".source = "${up}/bin/up";
  xdg.configFile."leftwm/theme.ron".text = with theme.colors; ''
    (
      border_width: 1,
      margin: 0,
      default_border_color: "${color0}",
      floating_border_color: "${color10}",
      focused_border_color: "${color5}",
    )
  '';
  xdg.configFile."leftwm/config.ron".text = ''
    #![enable(implicit_some)]
    (
        modkey: "Mod4",
        mousekey: "Mod4",
        workspaces: [],
        tags: [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
        ],
        max_window_width: None,
        layouts: [
            MainAndVertStack,
            MainAndHorizontalStack,
            Monocle,
        ],
        layout_mode: Tag,
        insert_behavior: Bottom,
        window_rules: [],
        disable_current_tag_swap: false,
        disable_tile_drag: false,
        disable_window_snap: true,
        focus_behaviour: ClickTo,
        focus_new_windows: true,
        single_window_border: false,
        auto_derive_workspaces: true,
        keybind: [
            (command: CloseWindow, value: "", modifier: ["modkey", "Shift"], key: "q"),
            (command: SoftReload, value: "", modifier: ["modkey", "Shift"], key: "r"),
            (command: Execute, value: "loginctl kill-session $XDG_SESSION_ID", modifier: ["modkey", "Shift"], key: "x"),
            (command: MoveToLastWorkspace, value: "", modifier: ["modkey", "Shift"], key: "w"),
            (command: SwapTags, value: "", modifier: ["modkey"], key: "w"),
            (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "k"),
            (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "j"),
            (command: MoveWindowTop, value: "", modifier: ["modkey"], key: "Return"),
            (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "k"),
            (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "j"),
            (command: NextLayout, value: "", modifier: ["modkey", "Control"], key: "k"),
            (command: PreviousLayout, value: "", modifier: ["modkey", "Control"], key: "j"),
            (command: FocusWorkspaceNext, value: "", modifier: ["modkey"], key: "l"),
            (command: FocusWorkspacePrevious, value: "", modifier: ["modkey"], key: "h"),
            (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "Up"),
            (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "Down"),
            (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "Up"),
            (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "Down"),
            (command: NextLayout, value: "", modifier: ["modkey", "Control"], key: "Up"),
            (command: PreviousLayout, value: "", modifier: ["modkey", "Control"], key: "Down"),
            (command: FocusWorkspaceNext, value: "", modifier: ["modkey"], key: "Right"),
            (command: FocusWorkspacePrevious, value: "", modifier: ["modkey"], key: "Left"),
            (command: GotoTag, value: "1", modifier: ["modkey"], key: "1"),
            (command: GotoTag, value: "2", modifier: ["modkey"], key: "2"),
            (command: GotoTag, value: "3", modifier: ["modkey"], key: "3"),
            (command: GotoTag, value: "4", modifier: ["modkey"], key: "4"),
            (command: GotoTag, value: "5", modifier: ["modkey"], key: "5"),
            (command: GotoTag, value: "6", modifier: ["modkey"], key: "6"),
            (command: GotoTag, value: "7", modifier: ["modkey"], key: "7"),
            (command: GotoTag, value: "8", modifier: ["modkey"], key: "8"),
            (command: GotoTag, value: "9", modifier: ["modkey"], key: "9"),
            (command: MoveToTag, value: "1", modifier: ["modkey", "Shift"], key: "1"),
            (command: MoveToTag, value: "2", modifier: ["modkey", "Shift"], key: "2"),
            (command: MoveToTag, value: "3", modifier: ["modkey", "Shift"], key: "3"),
            (command: MoveToTag, value: "4", modifier: ["modkey", "Shift"], key: "4"),
            (command: MoveToTag, value: "5", modifier: ["modkey", "Shift"], key: "5"),
            (command: MoveToTag, value: "6", modifier: ["modkey", "Shift"], key: "6"),
            (command: MoveToTag, value: "7", modifier: ["modkey", "Shift"], key: "7"),
            (command: MoveToTag, value: "8", modifier: ["modkey", "Shift"], key: "8"),
            (command: MoveToTag, value: "9", modifier: ["modkey", "Shift"], key: "9"),
        ],
        state_path: None,
    )
  '';
}
{ theme, config, pkgs, lib, ... }:
let
  configFolder = "${config.xdg.configHome}/leftwm";
  up = pkgs.writeShellScriptBin "up" ''
    if [ -f "/tmp/leftwm-theme-down" ]; then
      /tmp/leftwm-theme-down
      rm /tmp/leftwm-theme-down
    fi
    ln -s ${down}/bin/down /tmp/leftwm-theme-down

    ${pkgs.leftwm}/bin/leftwm-command "LoadTheme ${configFolder}/theme.ron"

    index=0
    monitors="$(${pkgs.polybar}/bin/polybar -m | ${pkgs.gnused}/bin/sed s/:.*//)"
    ${pkgs.leftwm}/bin/leftwm-state -q -n -t ${configFolder}/sizes.liquid | ${pkgs.gnused}/bin/sed -r '/^\s*$/d' | while read -r width x y
    do
      let indextemp=index+1
      monitor=$(${pkgs.gnused}/bin/sed "$indextemp!d" <<<"$monitors")
      barname="mainbar$index"
      monitor=$monitor offset=$x width=$width ${pkgs.polybar}/bin/polybar -c ${configFolder}/polybar.config $barname &> /dev/null &
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
  xdg.configFile."leftwm/config.ron".text =
  let
    tags = lib.lists.range 1 9;
    stringify = s: "\"${toString s}\"";
    stringifyArray = ar: "[${builtins.concatStringsSep "," (map (a: stringify a) ar)}]";
    command = c: v: m: k: "(command: ${c}, value: ${stringify v}, modifier: ${stringifyArray m}, key: ${stringify k})";
    handlTags = c: m: builtins.concatStringsSep ",\n      " (map (t: "${command c t m t}") tags);
  in
  ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    (
        modkey: "Mod4",
        mousekey: "Mod4",
        workspaces: [],
        tags: ${ stringifyArray tags },
        max_window_width: None,
        layouts: [
          "MainAndVertStack",
          "MainAndHorizontalStack",
          "Monocle",
        ],
        layout_definitions: [
          (name: "MainAndVertStack", flip: None, rotate: North, reserve: None, columns: (flip: None, rotate: North, main: (count: 1, size: 0.5, flip: None, rotate: North, split: Vertical), stack: (flip: None, rotate: North, split: Horizontal), second_stack: None)),
          (name: "MainAndHorizontalStack", flip: None, rotate: North, reserve: None, columns: (flip: None, rotate: North, main: (count: 1, size: 0.5, flip: None, rotate: North, split: Vertical), stack: (flip: None, rotate: North, split: Vertical), second_stack: None)),
          (name: "Monocle", flip: None, rotate: North, reserve: None, columns: (flip: None, rotate: North, main: None, stack: (flip: None, rotate: North, split: None), second_stack: None)),
        ],
        scratchpad: [
          (name: "EasyEffects", value: "easyeffects", x: 0.1, y: 0.1, height: 0.8, width: 0.8),
        ],
        layout_mode: Tag,
        insert_behavior: Bottom,
        window_rules: [],
        disable_current_tag_swap: true,
        disable_tile_drag: false,
        disable_window_snap: true,
        focus_behaviour: ClickTo,
        focus_new_windows: true,
        single_window_border: false,
        auto_derive_workspaces: true,
        keybind: [
          ${command "Execute" "alacritty" ["modkey" "Shift"] "Return"},
          ${command "Execute" "chromium" ["modkey" "Shift"] "w"},
          ${command "ToggleScratchPad" "EasyEffects" ["modkey" "Shift"] "e"},
          ${command "CloseWindow" "" ["modkey" "Shift"] "c"},
          ${command "SoftReload" "" ["modkey"] "q"},
          ${command "Execute" "loginctl kill-session $XDG_SESSION_ID" ["modkey" "Shift"] "q"},
          ${command "MoveToLastWorkspace" "" ["modkey" "Shift"] "w"},
          ${command "SwapTags" "" ["modkey"] "w"},
          ${command "MoveWindowUp" "" ["modkey" "Shift"] "k"},
          ${command "MoveWindowDown" "" ["modkey" "Shift"] "j"},
          ${command "MoveWindowTop" "" ["modkey"] "Return"},
          ${command "FocusWindowUp" "" ["modkey"] "k"},
          ${command "FocusWindowDown" "" ["modkey"] "j"},
          ${command "NextLayout" "" ["modkey" "Control"] "k"},
          ${command "PreviousLayout" "" ["modkey" "Control"] "j"},
          ${command "FocusWorkspaceNext" "" ["modkey"] "l"},
          ${command "FocusWorkspacePrevious" "" ["modkey"] "h"},
          ${handlTags "GotoTag" ["modkey"]},
          ${handlTags "MoveToTag" ["modkey" "Shift"]},
        ],
        state_path: None,
    )
  '';
}

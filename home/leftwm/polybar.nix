{ theme, config, dpi, dpiRatio, pkgs, ... }:
let
change_to_tag = pkgs.writeShellScriptBin "change_to_tag" ''
  ${pkgs.leftwm}/bin/leftwm-command "SendWorkspaceToTag $1 $2"
'';
configFolder = "${config.xdg.configHome}/leftwm";
in
{
  xdg.configFile."leftwm/sizes.liquid".text = ''
    {% for workspace in workspaces %}
    {{workspace.w}} {{workspace.x}} {{workspace.y}}
    {% endfor %}
  '';
  xdg.configFile."leftwm/template.liquid".text = with theme.colors; ''
    {% for tag in workspace.tags %}
    {% if tag.mine %}
    %{A1:${change_to_tag}/bin/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{F${color0}}%{B${color3}}  {{tag.name}}  %{B-}%{F-}
    %{A}
    {% elsif tag.urgent %}
    %{A1:${change_to_tag}/bin/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{B${color1}}%{F${color0}}  {{tag.name}}  %{F-}%{B-}
    %{A}
    {% elsif tag.visible  %}
    %{A1:${change_to_tag}/bin/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{F${color0}}%{B${color15}}  {{tag.name}}  %{B-}%{F-}
    %{A}
    {% elsif tag.busy %}
    %{A1:${change_to_tag}/bin/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{F${color3}}  {{tag.name}}  %{F-}
    %{A}
    {% else %}
    %{A1:${change_to_tag}/bin/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{A}
    {% endif %}
    {% endfor %}
    {% if workspace.layout == "MainAndVertStack" %}
    %{F${color0}}%{B${foreground}} Vert %{B-}%{F-}
    {% elsif workspace.layout == "MainAndHorizontalStack" %}
    %{F${color0}}%{B${foreground}} Hori %{B-}%{F-}
    {% elsif workspace.layout == "Monocle" %}
    %{F${color0}}%{B${foreground}} Full %{B-}%{F-}
    {% endif %}
    {% if window_title != "" %}
     %{F${color2}} * {{ window_title }} *
    {% endif %}
  '';
  xdg.configFile."leftwm/polybar.config".text = with theme.colors; with pkgs; ''
    [colors]
    background = ${background}
    foreground = ${color15}
    background-alt = #444444
    foreground-alt = #FFFFFF
    primary = ${color3}
    secondary = ${color9}
    alert = ${color1}

    [bar/mainbar0]
    inherit = bar/barbase
    modules-left = workspace0
    [module/workspace0]
    type = custom/script
    exec = ${leftwm}/bin/leftwm-state -w 0 -t ${configFolder}/template.liquid
    tail = true

    [bar/mainbar1]
    inherit = bar/barbase
    modules-left = workspace1
    [module/workspace1]
    type = custom/script
    exec = ${leftwm}/bin/leftwm-state -w 1 -t ${configFolder}/template.liquid
    tail = true

    [bar/mainbar2]
    inherit = bar/barbase
    modules-left = workspace2
    [module/workspace2]
    type = custom/script
    exec = ${leftwm}/bin/leftwm-state -w 2 -t ${configFolder}/template.liquid
    tail = true

    [bar/mainbar3]
    inherit = bar/barbase
    modules-left = workspace3
    [module/workspace3]
    type = custom/script
    exec = ${leftwm}/bin/leftwm-state -w 3 -t ${configFolder}/template.liquid
    tail = true


    [bar/barbase]
    width = ''${env:width}
    offset-x = ''${env:offset}
    monitor = ''${env:monitor}
    ;offset-y = ''${env:y}
    ;width = 100%
    height = ${toString (24 * dpiRatio)}
    dpi=${toString dpi}
    fixed-center = false
    background = ''${colors.background}
    foreground = ''${colors.foreground}
    line-size = 3
    line-color = #f00
    border-size = 0
    border-color = #00000000
    padding-left = 0
    padding-right = 0
    module-margin-left = 1
    module-margin-right = 2
    font-0 = Noto Sans:size=13;1
    ;font-1 = NotoSans Nerd Font:style=Regular:size=9;1
    modules-center =
    modules-right = filesystem xbacklight memory cpu wlan battery temperature date powermenu
    tray-position = right
    tray-padding = 2
    tray-scale = 1.0
    tray-maxsize = ${toString (18 * dpiRatio)}
    cursor-click = pointer
    cursor-scroll = ns-resize

    [module/ewmh]
    type = internal/xworkspaces
    label-active = " %icon% %name%  "
    label-active-foreground = ''${colors.foreground-alt}
    label-active-background = ''${colors.background-alt}
    label-active-underline = ''${colors.primary}
    label-occupied = " %icon% %name%  "
    label-occupied-underline = ''${colors.secondary}
    label-urgent = " %icon% %name%  "
    label-urgent-foreground = ''${colors.foreground}
    label-urgent-background = ''${colors.background}
    label-urgent-underline  = ''${colors.alert}
    label-empty = " %icon% %name%  "
    label-empty-foreground = ''${colors.foreground}


    [module/xwindow]
    type = internal/xwindow
    label = %title:0:30:...%

    [module/xkeyboard]
    type = internal/xkeyboard
    blacklist-0 = num lock

    format-prefix = " "
    format-prefix-foreground = ''${colors.foreground-alt}
    format-prefix-underline = ''${colors.secondary}

    label-layout = %layout%
    label-layout-underline = ''${colors.secondary}

    label-indicator-padding = 2
    label-indicator-margin = 1
    label-indicator-background = ''${colors.secondary}
    label-indicator-underline = ''${colors.secondary}

    [module/filesystem]
    type = internal/fs
    interval = 25

    mount-0 = /

    label-mounted = %{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%
    label-unmounted = %mountpoint% not mounted
    label-unmounted-foreground = ''${colors.foreground-alt}

    [module/mpd]
    type = internal/mpd
    format-online = <label-song>  <icon-prev> <icon-stop> <toggle> <icon-next>

    icon-prev = 
    icon-stop = 
    icon-play = 
    icon-pause = 
    icon-next = 

    label-song-maxlen = 25
    label-song-ellipsis = true

    [module/xbacklight]
    type = internal/xbacklight

    format = <label> <bar>
    label = BL

    bar-width = 10
    bar-indicator = |
    bar-indicator-foreground = #fff
    bar-indicator-font = 2
    bar-fill = ─
    bar-fill-font = 2
    bar-fill-foreground = #8787af
    bar-empty = ─
    bar-empty-font = 2
    bar-empty-foreground = ''${colors.foreground-alt}

    [module/backlight-acpi]
    inherit = module/xbacklight
    type = internal/backlight
    card = intel_backlight

    [module/cpu]
    type = internal/cpu
    interval = 2
    format-prefix = " "
    format-prefix-foreground = ''${colors.foreground-alt}
    format-underline = #cf6a4c
    label = %percentage:2%%

    [module/memory]
    type = internal/memory
    interval = 2
    format-prefix = " "
    format-prefix-foreground = ''${colors.foreground-alt}
    format-underline = #8197bf
    label = %percentage_used%%

    [module/wlan]
    type = internal/network
    interface = wlan0
    interval = 3.0

    format-connected = <ramp-signal> <label-connected>
    format-connected-underline = #c4c4ff
    label-connected = %essid%

    format-disconnected =
    ;format-disconnected = <label-disconnected>
    ;format-disconnected-underline = ''${self.format-connected-underline}
    ;label-disconnected = %ifname% disconnected
    ;label-disconnected-foreground = ''${colors.foreground-alt}

    ramp-signal-0 = 
    ramp-signal-1 = 
    ramp-signal-2 = 
    ramp-signal-3 = 
    ramp-signal-4 = 
    ramp-signal-foreground = ''${colors.foreground-alt}

    [module/eth]
    type = internal/network
    interface = enp0s25
    interval = 3.0

    format-connected-underline = #55aa55
    format-connected-prefix = " "
    format-connected-prefix-foreground = ''${colors.foreground-alt}
    label-connected = %local_ip%

    format-disconnected =
    ;format-disconnected = <label-disconnected>
    ;format-disconnected-underline = ''${self.format-connected-underline}
    ;label-disconnected = %ifname% disconnected
    ;label-disconnected-foreground = ''${colors.foreground-alt}

    [module/date]
    type = internal/date
    date = %%{F#fff}%I:%M:%{F#666}%%{F#fba922}%S%%{F-} %p
    date-alt = %%{F#fff}%A, %B %d, %Y  %%{F#fff}%I:%M:%{F#666}%%{F#fba922}%S%%{F-} %p
    ;interval = 5
    ;date =
    ;date-alt = " %Y-%m-%d"
    ;time = %H:%M
    ;time-alt = %H:%M:%S
    ;format-prefix = 
    ;format-prefix-foreground = ''${colors.foreground-alt}
    ;format-underline = #0a6cf5
    ;label = %date% %time%

    [module/pulseaudio]
    type = internal/pulseaudio

    format-volume = <label-volume> <bar-volume>
    label-volume = VOL %percentage%%
    label-volume-foreground = ''${root.foreground}

    label-muted = 🔇 muted
    label-muted-foreground = #666

    bar-volume-width = 10
    bar-volume-foreground-0 = #55aa55
    bar-volume-foreground-1 = #55aa55
    bar-volume-foreground-2 = #55aa55
    bar-volume-foreground-3 = #55aa55
    bar-volume-foreground-4 = #55aa55
    bar-volume-foreground-5 = #f5a70a
    bar-volume-foreground-6 = #ff5555
    bar-volume-gradient = false
    bar-volume-indicator = |
    bar-volume-indicator-font = 2
    bar-volume-fill = ─
    bar-volume-fill-font = 2
    bar-volume-empty = ─
    bar-volume-empty-font = 2
    bar-volume-empty-foreground = ''${colors.foreground-alt}

    [module/alsa]
    type = internal/alsa

    format-volume = <label-volume> <bar-volume>
    label-volume = VOL
    label-volume-foreground = ''${root.foreground}

    format-muted-prefix = " "
    format-muted-foreground = ''${colors.foreground-alt}
    label-muted = sound muted

    bar-volume-width = 10
    bar-volume-foreground-0 = #55aa55
    bar-volume-foreground-1 = #55aa55
    bar-volume-foreground-2 = #55aa55
    bar-volume-foreground-3 = #55aa55
    bar-volume-foreground-4 = #55aa55
    bar-volume-foreground-5 = #f5a70a
    bar-volume-foreground-6 = #ff5555
    bar-volume-gradient = false
    bar-volume-indicator = |
    bar-volume-indicator-font = 2
    bar-volume-fill = ─
    bar-volume-fill-font = 2
    bar-volume-empty = ─
    bar-volume-empty-font = 2
    bar-volume-empty-foreground = ''${colors.foreground-alt}

    [module/battery]
    type = internal/battery
    battery = BAT0
    adapter = AC
    full-at = 98

    format-charging = <animation-charging> <label-charging>
    format-charging-underline = #ffb52a

    format-discharging = <animation-discharging> <label-discharging>
    format-discharging-underline = ''${self.format-charging-underline}

    format-full-prefix = " "
    format-full-prefix-foreground = ''${colors.foreground-alt}
    format-full-underline = ''${self.format-charging-underline}

    ramp-capacity-0 = 
    ramp-capacity-1 = 
    ramp-capacity-2 = 
    ramp-capacity-foreground = ''${colors.foreground-alt}

    animation-charging-0 = 
    animation-charging-1 = 
    animation-charging-2 = 
    animation-charging-foreground = ''${colors.foreground-alt}
    animation-charging-framerate = 750

    animation-discharging-0 = 
    animation-discharging-1 = 
    animation-discharging-2 = 
    animation-discharging-foreground = ''${colors.foreground-alt}
    animation-discharging-framerate = 750

    [module/temperature]
    type = internal/temperature
    thermal-zone = 0
    warn-temperature = 60

    format = <ramp> <label>
    format-underline = #fad07a
    format-warn = <ramp> <label-warn>
    format-warn-underline = ''${self.format-underline}

    label = %temperature-c%
    label-warn = %temperature-c%
    label-warn-foreground = ''${colors.secondary}

    ramp-0 = 
    ramp-1 = 
    ramp-2 = 
    ramp-foreground = ''${colors.foreground-alt}

    [module/powermenu]
    type = custom/menu

    expand-right = true

    format-spacing = 1

    label-open = 
    label-open-foreground = ''${colors.secondary}
    label-close =  cancel
    label-close-foreground = ''${colors.secondary}
    label-separator = |
    label-separator-foreground = ''${colors.foreground-alt}

    menu-0-0 = reboot
    menu-0-0-exec = menu-open-1
    menu-0-1 = power off
    menu-0-1-exec = menu-open-2

    menu-1-0 = cancel
    menu-1-0-exec = menu-open-0
    menu-1-1 = reboot
    menu-1-1-exec = sudo reboot

    menu-2-0 = power off
    menu-2-0-exec = sudo poweroff
    menu-2-1 = cancel
    menu-2-1-exec = menu-open-0

    [settings]
    screenchange-reload = true
    ;compositing-background = xor
    ;compositing-background = screen
    ;compositing-foreground = source
    ;compositing-border = over
    ;pseudo-transparency = false

    ;[global/wm]
    ;margin-top = 5
    ;margin-bottom = 5

    ; vim:ft=dosini
  '';
}

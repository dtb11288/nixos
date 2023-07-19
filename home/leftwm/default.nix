{ theme, ... }:
{
  xdg.configFile."leftwm" = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."leftwm/themes/current/sizes.liquid".text = ''
    {% for workspace in workspaces %}
    {{workspace.w}} {{workspace.x}} {{workspace.y}}
    {% endfor %}
  '';
  xdg.configFile."leftwm/themes/current/theme.ron".text = with theme.colors; ''
    (
        border_width: 1,
        margin: 0,
        default_border_color: "${color0}",
        floating_border_color: "${color10}",
        focused_border_color: "${color5}",
    )
  '';
  xdg.configFile."leftwm/themes/current/template.liquid".text = with theme.colors; ''
    {% for tag in workspace.tags %}
    {% if tag.mine %}
    %{A1:$SCRIPTPATH/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{F${color0}}%{B${color3}}  {{tag.name}}  %{B-}%{F-}
    %{A}
    {% elsif tag.urgent %}
    %{A1:$SCRIPTPATH/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{B${color1}}%{F${color0}}  {{tag.name}}  %{F-}%{B-}
    %{A}
    {% elsif tag.visible  %}
    %{A1:$SCRIPTPATH/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{F${color0}}%{B${color15}}  {{tag.name}}  %{B-}%{F-}
    %{A}
    {% elsif tag.busy %}
    %{A1:$SCRIPTPATH/change_to_tag {{workspace.index}} {{tag.index}}:}
    %{F${color3}}  {{tag.name}}  %{F-}
    %{A}
    {% else %}
    %{A1:$SCRIPTPATH/change_to_tag {{workspace.index}} {{tag.index}}:}
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
     %{F${color2}} {{ window_title }}
  '';
}

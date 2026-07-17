{ theme }:

let
  c = theme.colors;
in
{
  "$schema" = "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
  name = "vintage-earth";

  vars = {
    bg = c.background;
    text = c.color15;
    fg = c.color7;
    muted = c.foreground;
    dim = c.color8;

    red = c.color1;
    brightRed = c.color9;
    green = c.color2;
    brightGreen = c.color10;
    yellow = c.color3;
    brightYellow = c.color11;
    blue = c.color4;
    brightBlue = c.color12;
    purple = c.color5;
    brightPurple = c.color13;
    teal = c.color6;
    brightTeal = c.color14;

    # interstitial backgrounds (between bg and color0)
    bg2 = "#1c1c1c";
    bg3 = "#222224";
    lineBg = "#252528";
    selectedBg = c.color0;
  };

  colors = {
    # Core UI
    accent = "teal";
    border = "blue";
    borderAccent = "brightTeal";
    borderMuted = "bg3";
    success = "green";
    error = "red";
    warning = "yellow";
    muted = "muted";
    dim = "dim";
    text = "text";
    thinkingText = "muted";

    # Backgrounds & Content
    selectedBg = "selectedBg";
    userMessageBg = "lineBg";
    userMessageText = "text";
    customMessageBg = "selectedBg";
    customMessageText = "text";
    customMessageLabel = "brightPurple";
    toolPendingBg = "bg3";
    toolSuccessBg = "bg2";
    toolErrorBg = "bg2";
    toolTitle = "text";
    toolOutput = "fg";

    # Markdown
    mdHeading = "yellow";
    mdLink = "brightBlue";
    mdLinkUrl = "muted";
    mdCode = "brightTeal";
    mdCodeBlock = "brightGreen";
    mdCodeBlockBorder = "muted";
    mdQuote = "muted";
    mdQuoteBorder = "muted";
    mdHr = "muted";
    mdListBullet = "teal";

    # Tool Diffs
    toolDiffAdded = "green";
    toolDiffRemoved = "red";
    toolDiffContext = "muted";

    # Syntax Highlighting
    syntaxComment = "dim";
    syntaxKeyword = "brightBlue";
    syntaxFunction = "yellow";
    syntaxVariable = "brightPurple";
    syntaxString = "brightRed";
    syntaxNumber = "brightGreen";
    syntaxType = "brightTeal";
    syntaxOperator = "fg";
    syntaxPunctuation = "fg";

    # Thinking Level Borders
    thinkingOff = "bg3";
    thinkingMinimal = "dim";
    thinkingLow = "blue";
    thinkingMedium = "teal";
    thinkingHigh = "purple";
    thinkingXhigh = "brightPurple";
    thinkingMax = "brightRed";

    # Bash Mode
    bashMode = "green";
  };

  export = {
    pageBg = "bg";
    cardBg = "bg2";
    infoBg = "selectedBg";
  };
}

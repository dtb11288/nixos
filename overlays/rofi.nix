final: prev: {
  rofi = prev.rofi.override { plugins = [ prev.rofi-calc prev.rofi-emoji ]; };
}

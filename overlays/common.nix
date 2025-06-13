final: prev: {
  common = {
    locker = "/run/wrappers/bin/slock";
    terminal = "${prev.alacritty}/bin/alacritty";
  };
}

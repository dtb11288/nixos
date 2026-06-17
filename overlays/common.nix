final: prev: {
  common = {
    locker = "/run/wrappers/bin/slock";
    terminal = "${prev.foot}/bin/foot";
  };
}

{ config, ... }:
{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
        savePath = "${config.xdg.configHome}/ScreenShots";
        savePathFixed = true;
      };
    };
  };
}

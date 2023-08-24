{ config, ... }:
{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
        savePath = "${config.home.homeDirectory}/ScreenShots";
        savePathFixed = true;
      };
    };
  };
}

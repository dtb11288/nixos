{ username, ... }:
{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showStartupLaunchMessage = false;
        savePath = "/home/${username}/ScreenShots";
        savePathFixed = true;
      };
    };
  };
}

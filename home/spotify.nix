{ ... }:
{
  xdg.configFile."spotify-player/app.toml".text = ''
    [device]
    name = "spotify-player"
    device_type = "speaker"
    volume = 100
    bitrate = 320
    audio_cache = false
  '';
}

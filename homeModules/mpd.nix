{ lib, config, pkgs, ... }:

{
  options = { mpd.enable = lib.mkEnableOption "enable mpd music daemon"; };

  config = lib.mkIf config.mpd.enable {
    services.mpd = {
      enable = true;
      musicDirectory = "/mnt/1tb/Music/";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
      network.listenAddress = "any";
      network.startWhenNeeded = true;
    };
    services.listenbrainz-mpd.enable = true;
    home.packages = with pkgs; [ mpd-notification ];
  };
}

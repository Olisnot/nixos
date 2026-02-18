{ lib, config, ... }:

{
  options.navidrome.enable = lib.mkEnableOption "Start Navidrome service";

  config = lib.mkIf config.navidrome.enable {
	services.navidrome = {
		enable = true;
		openFirewall = true;
		settings = {
			MusicFolder = "/mnt/1tb/Music";
		};
	};
  };
}

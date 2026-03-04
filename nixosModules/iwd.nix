{ lib, config, pkgs, ... }:

{
	options.iwd.enable = lib.mkEnableOption "Enable iwd";

	config = lib.mkIf config.iwd.enable {
		networking.wireless.iwd.settings = {
			IPv6 = {
				Enabled = true;
			};
			Settings = {
				AutoConnect = true;
			};
		};
		environment.systemPackages = with pkgs; [ impala ];
	};
}

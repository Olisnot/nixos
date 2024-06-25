{pkgs, config, libs, inputs, ... }:

{
# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.oliver = {
		isNormalUser = true;
		description = "Oliver";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
		];
	};

	home-manager = { 
		backupFileExtension = "hm-backup";
		extraSpecialArgs = {inherit inputs;};
		users = {
			"oliver" = import ../home.nix;
		};
	};
}

{ inputs, ... }:

{
# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.oliver = {
		isNormalUser = true;
		description = "Oliver";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	home-manager = { 
		backupFileExtension = "backup41";
		extraSpecialArgs = {inherit inputs;};
		users = {
			"oliver" = import ../home.nix;
		};
	};
}

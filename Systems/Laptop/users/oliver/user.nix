{ inputs, ... }:

{
# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.oliver = {
		isNormalUser = true;
		description = "Oliver";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	home-manager = { 
                backupFileExtension = "backup84";
		extraSpecialArgs = {inherit inputs;};
                #useGlobalPkgs = true;
		users = {
			"oliver" = import ./home.nix;
		};
	};
}

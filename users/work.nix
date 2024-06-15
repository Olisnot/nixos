{pkgs, config, libs, inputs, ... }:

{
# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.work = {
		isNormalUser = true;
		description = "Work";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
            globalprotect-openconnect
		];
	};

	home-manager = { 
		extraSpecialArgs = {inherit inputs;};
		users = {
			"work" = import ../home.nix;
		};
	};
}

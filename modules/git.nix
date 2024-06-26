{ pkgs, config, libs, ... }:

{
	programs.git = {
		enable = true;
		userName = "Olisnot";
		userEmail = "oliverpm2007@gmail.com";
		extraConfig = {
			credential.helper = "store --file ~/.git-credentials";
		};
	};
}


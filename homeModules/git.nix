{ ... }:

{
	programs.git = {
		enable = true;
		userName = "Olisnot";
		userEmail = "oliverpm2007@gmail.com";
                aliases = {
                  cm = "commit";
                  a = "add";
                  co = "checkout";
                  r = "rebase";
                  m = "merge";
                };
	};
}


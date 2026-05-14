{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    gnupg.enable = lib.mkEnableOption "Enable gnupg for pgp keys";
  };

  config = lib.mkIf config.gnupg.enable {
	  programs.gnupg = {
		  agent = {
			  enable = true;
			  pinentryPackage = pkgs.pinentry-curses;
		  };
	  };
  };
}

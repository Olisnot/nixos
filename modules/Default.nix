{ pkgs, config, libs, ... }:

{
	imports = [
		./nvidia.nix
		./NixVim/Default.nix
		./Gaming/Default.nix
		./git.nix
		./tmux.nix
		./redshift.nix
		./virt-manager.nix
		./aliases.nix
	];
}

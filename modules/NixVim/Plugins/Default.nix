{ pkgs, inputs, ... }: 

{
	imports = [
		./telescope.nix
		./undotree.nix
		./lsp.nix
		./treesitter.nix
	];
}
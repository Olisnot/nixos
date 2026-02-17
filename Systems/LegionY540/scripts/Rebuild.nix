{ pkgs }:

pkgs.writeShellApplication {
	name = "rebuild";
	text = # bash
		''
		if sudo nixos-rebuild switch --impure --flake /home/oliver/repos/nixos#legiony540; then
			cd /home/oliver/repos/nixos  || exit
			git add .
			if ! git diff --cached --quiet; then
				generation=$(nixos-rebuild list-generations | ${pkgs.ripgrep}/bin/rg True | awk '{print substr($0, 1, 4)}')
				git commit -m "Generation-$generation-$(date +"%d-%m-%Y %H:%M:%S")"
			else
				echo "No changes to commit."
			fi
		else 
			echo "Build Failed"
		fi
	'';
}

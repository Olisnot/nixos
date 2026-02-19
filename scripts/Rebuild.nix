{ pkgs }:

pkgs.writeShellApplication {
	name = "rebuild";
	text = # bash
		''
		host=$(hostname)
		git add .
		if sudo nixos-rebuild switch --impure --flake /home/oliver/repos/nixos#"$host"; then
			cd /home/oliver/repos/nixos  || exit
			if ! git diff --cached --quiet; then
				generation=$(nixos-rebuild list-generations | ${pkgs.ripgrep}/bin/rg True | awk '{sub(/[[:space:]]+$/, ""); print substr($0, 1, 4)}')
				git commit -m "Generation-$generation"
			else
				echo "No changes to commit."
			fi
		else 
			echo "Build Failed"
		fi
	'';
}

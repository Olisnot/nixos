{ pkgs }:

pkgs.writeShellApplication {
	name = "rebuild";
	text = # bash
		''
		if sudo nixos-rebuild switch --impure --flake /home/oliver/repos/nixos#legiony540; then
			cd /home/oliver/repos/nixos  || exit
				git add .
				if ! git diff --cached --quiet; then
					git commit -m "rebuild-$(date +"%d-%m-%Y %H:%M:%S")"
				else
					echo "No changes to commit."
				fi
		else 
			echo "Build Failed"
		fi
	'';
}

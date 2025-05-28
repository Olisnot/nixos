{ pkgs }:

pkgs.writeShellApplication {
  name = "code";
  text = /* bash */ ''
  selected=$(fd --type d --max-depth 1 . ~/repos | sk)
  session_name=$(basename "$selected" | tr . _)

  cd "$selected"
  zellij attach "$session_name" -c
  exit 0
  '';
}

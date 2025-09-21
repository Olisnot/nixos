{ pkgs, ... }:

let
  sk = "${pkgs.skim}/bin/sk";
  fd = "${pkgs.fd}/bin/fd";
  tmux = "${pkgs.tmux}/bin/tmux";

in pkgs.writeShellApplication {
  name = "code";
  text = # bash
    ''
      selected=$(${fd} --type d --max-depth 1 . ~/repos | ${sk})
      session_name=$(basename "$selected" | tr . _)

      cd "$selected"
      ${tmux} new -A -s "$session_name"
      exit 0
    '';
}

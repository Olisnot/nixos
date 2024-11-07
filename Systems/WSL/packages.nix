{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    ripgrep
    git
  ];
}

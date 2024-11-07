{ pkgs, inputs, ... }:

let
  nvim = inputs.nixvim.packages."x86_64-linux".default;
in
{
  environment.systemPackages = with pkgs; [
    tmux
    git
    nvim
  ];
}

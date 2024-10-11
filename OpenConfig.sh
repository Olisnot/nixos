#!/usr/bin/env bash
cd /nixos
tmux new-session -s NixOSConfig -n Rebuild
tmux new-window -t NixOSConfig:2 -n NeoVim
tmux send-keys -t NixOSConfig:2 'sudovim'

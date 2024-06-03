#!/usr/bin/env bash
cd /nixos
sudo git add .
sudo git commit -m "rebuild"
sudo nixos-rebuild switch --flake /nixos#default

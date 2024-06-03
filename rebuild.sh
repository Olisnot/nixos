#!/usr/bin/env bash
cd /nixos
sudo git add .
sudo git commit -m "rebuild-"$(date +"%d-%m-%Y")
sudo nixos-rebuild switch --flake /nixos#default

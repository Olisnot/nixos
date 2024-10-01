#!/usr/bin/env bash
cd /nixos 
sudo git add . 
sudo git commit -m "rebuild-$(date +"%d-%m-%Y %H:%M:%S")"
sudo nixos-rebuild switch --impure --flake /nixos#default

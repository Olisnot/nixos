#!/usr/bin/env bash
cd /nixos
git add .
git commit -m "rebuild"
sudo nixos-rebuild switch --flake /nixos#default

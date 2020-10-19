#!/usr/bin/env bash
# Quick way to setup nix, home-manager, and marco's home manager config
set -e
curl -L https://nixos.org/nix/install | sh
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
(cd ~/.config && git clone https://github.com/MarcoPolo/home nixpkgs)
nix-shell '<home-manager>' -A install
home-manager build
home-manager switch

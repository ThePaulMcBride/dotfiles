# Dotfiles

Clone this repo into the home directory. With Nix and Nix Darwin installed, run `nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles/nix-darwin#{home|work}`.

This also works for NixOS, but you will need to run `nixos-rebuild switch --flake ~/dotfiles/nixos#hostname` instead.

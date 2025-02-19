{ pkgs, lib, ... }:

{
  # enable flakes globally
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # required for nix to work with Determinate
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nix.settings = {
    auto-optimise-store = true;
  };
}

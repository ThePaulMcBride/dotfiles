{ ... }: {
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };
  nix.settings.auto-optimise-store = true;
}

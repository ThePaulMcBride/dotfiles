{ pkgs, ... }:
{

  # environment.systemPackages =
  #   with pkgs;
  #   [
  #   ];

  homebrew = {
    brews = [
      "nvm"
    ];

    casks = [
      "asana"
      "google-chrome"
      "google-cloud-sdk"
      "loom"
    ];
  };
}

{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    capnproto
  ];

  homebrew = {
    brews = [
      "gcc"
      "imagemagick"
      "nvm"
      "pkgconf"
    ];

    casks = [
      "asana"
      "google-chrome"
      "google-cloud-sdk"
      "loom"
    ];
  };
}

{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    capnproto
    kubectl
    kubectx
  ];

  homebrew = {
    brews = [
      "gcc"
      "imagemagick"
      "libpq"
      "libyaml"
      "nvm"
      "pkgconf"
      "python@3.12"
    ];

    casks = [
      "asana"
      "google-chrome"
      "google-cloud-sdk"
      "loom"
    ];
  };
}

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
      "helm"
      "helmfile"
      "libpq"
      "libyaml"
      "nvm"
      "parallel"
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

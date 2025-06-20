{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    capnproto
    kubectl
    kubectx
  ];

  homebrew = {
    brews = [
      "circleci"
      "gcc"
      "graphviz"
      "imagemagick"
      "helm"
      "helmfile"
      "libpq"
      "libsodium"
      "libyaml"
      "nvm"
      "parallel"
      "pkgconf"
      "postgresql@15"
      "protobuf"
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

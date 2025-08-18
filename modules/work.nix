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
      "libpq"
      "libsodium"
      "libyaml"
      "nvm"
      "parallel"
      "pkgconf"
      "postgresql@15"
      "protobuf"
      "python@3.12"
      "stern"
    ];

    casks = [
      "asana"
      "google-chrome"
      "gcloud-cli"
      "loom"
    ];
  };
}

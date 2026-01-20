{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    capnproto
    claude-code
    opencode
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
      "terraform"
      "terragrunt"
    ];

    casks = [
      "asana"
      "google-chrome"
      "gcloud-cli"
    ];
  };
}

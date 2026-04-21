{ pkgs, username, ... }:
{

  environment.systemPackages = with pkgs; [
    capnproto
    claude-code
    helmfile
    opencode
    kubectl
    kubectx
  ];

  homebrew = {
    brews = [
      "circleci"
      "coreutils"
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
      "linear-linear"
    ];
  };

  system.activationScripts.helmDiff.text = ''
    if [ -x /opt/homebrew/bin/helm ] && ! sudo -u ${username} /opt/homebrew/bin/helm plugin list | ${pkgs.gnugrep}/bin/grep -q '^diff[[:space:]]'; then
      sudo -u ${username} /opt/homebrew/bin/helm plugin install --verify=false https://github.com/databus23/helm-diff
    fi
  '';

}

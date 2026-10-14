{ pkgs, user, ... }:
{

  environment.systemPackages = with pkgs; [
    capnproto
    claude-code
    helmfile
    kubectl
    kubectx
    (writeShellScriptBin "standup" (builtins.readFile ../scripts/standup.sh))
  ];

  homebrew = {
    taps = [ "schpet/tap" ];

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
      "linear"
      "nvm"
      "opencode"
      "parallel"
      "pi-coding-agent"
      "pkgconf"
      "postgresql@15"
      "protobuf"
      "python@3.12"
      "stern"
      "terraform"
      "terragrunt"
    ];

    casks = [
      "claude"
      "google-chrome"
      "gcloud-cli"
      "linear"
    ];
  };

  system.activationScripts.helmDiff.text = ''
    if [ -x /opt/homebrew/bin/helm ] && ! sudo -u ${user.name} /opt/homebrew/bin/helm plugin list | ${pkgs.gnugrep}/bin/grep -q '^diff[[:space:]]'; then
      sudo -u ${user.name} /opt/homebrew/bin/helm plugin install --verify=false https://github.com/databus23/helm-diff
    fi
  '';

}

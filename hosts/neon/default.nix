{ ... }:
{
  imports = [
    ../../modules/nix-core.nix
    ../../modules/nix-darwin.nix
    ../../modules/apps.nix
    ../../modules/host-users.nix
    ../../modules/nix-homebrew.nix
    ../../modules/home-manager-darwin.nix
    ../../modules/work.nix
  ];
}

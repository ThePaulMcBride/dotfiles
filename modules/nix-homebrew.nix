{ homebrew, user, ... }:
{
  imports = [
    homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user.name;
  };
}

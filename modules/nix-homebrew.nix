{ homebrew, username, ... }:
{
  imports = [
    homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
  };
}

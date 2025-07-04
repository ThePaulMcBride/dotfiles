{
  home-manager,
  specialArgs,
  username,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = specialArgs;
  home-manager.users.${username} = import ../hosts/home-darwin.nix;
}

{
  catppuccin,
  home-manager,
  specialArgs,
  user,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = specialArgs;
  home-manager.users.${user.name} = {
    imports = [
      ../modules/catppuccin.nix
      ../modules/home/platform-darwin.nix
      catppuccin.homeModules.catppuccin
    ];
  };
}

{
  catppuccin,
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
  home-manager.users.${username} = {
    imports = [
      ../modules/catppuccin.nix
      ../hosts/home-darwin.nix
      catppuccin.homeModules.catppuccin
    ];
  };
}

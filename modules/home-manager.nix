{
  catppuccin,
  home-manager,
  specialArgs,
  user,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.backupFileExtension = "bak";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = specialArgs;
  home-manager.users.${user.name} = {
    imports = [
      ../modules/catppuccin.nix
      ../modules/home/platform-linux.nix
      catppuccin.homeModules.catppuccin
    ];
  };
}

{
  catppuccin,
  home-manager,
  specialArgs,
  username,
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
  home-manager.users.${username} = {
    imports = [
      ../modules/catppuccin.nix
      ../hosts/home.nix
      catppuccin.homeModules.catppuccin
    ];
  };
}

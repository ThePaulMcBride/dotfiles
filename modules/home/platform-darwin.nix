{ config, pkgs, user, ... }:
{
  imports = [
    ./profile.nix
  ];

  home.homeDirectory = user.homeDirectory;

  home.packages = with pkgs; [
    (writeShellScriptBin "kd" (builtins.readFile ../../scripts/kd.sh))
  ];

  home.file = {
    ".config/ghostty/config".source = ../../dotfiles/ghostty/config;
    ".config/ghostty/themes".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/ghostty/themes";
  };
}

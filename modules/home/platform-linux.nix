{ config, ... }:
{
  imports = [
    ./profile.nix
  ];

  home.homeDirectory = "/home/${config.home.username}";

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

  home.file = {
    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/ghostty";
    ".config/niri/config.kdl".source = ../../dotfiles/niri/config.kdl;
  };
}

{ config, user, ... }:
{
  imports = [
    ./profile.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
  };

  home.homeDirectory = user.homeDirectory;

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

  home.file = {
    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/ghostty";
  };
}

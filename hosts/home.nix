{ config, username, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    # nixvim = {
    #   enable = true;
    #   colorschemes.catppuccin.enable = true;
    #   plugins.lualine.enable = true;
    # };
  };

  # Packages that should be installed to the user profile.
  home.packages = [
  ];

  home.file = {
    ".config/alacritty".source = ../dotfiles/alacritty;
    ".config/git".source = ../dotfiles/git;
    ".config/nix-darwin".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/nix-darwin";
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/nvim";
    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/ghostty";
    ".config/ohmyposh".source = ../dotfiles/ohmyposh;
    ".config/zellij".source = ../dotfiles/zellij;
    ".zshenv".source = ../dotfiles/zsh/.zshenv;
    ".config/zsh/.zshrc".source = ../dotfiles/zsh/.zshrc;
    ".config/zsh/path".source = ../dotfiles/zsh/path;
  };
}

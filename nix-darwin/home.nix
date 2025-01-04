{ config, username, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = "/Users/${username}";
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
    ".config/alacritty".source = ../alacritty;
    ".config/git".source = ../git;
    ".config/nix-darwin".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix-darwin";
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ghostty";
    ".config/ohmyposh".source = ../ohmyposh;
    ".config/zellij".source = ../zellij;
    ".zshenv".source = ../zsh/.zshenv;
    ".config/zsh/.zshrc".source = ../zsh/.zshrc;
    ".config/zsh/path".source = ../zsh/path;
  };
}

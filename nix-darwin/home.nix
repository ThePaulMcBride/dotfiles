{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "paul";
  home.homeDirectory = "/Users/paul";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = [
  ];

  home.file = {
    # ".config/alacritty".source = ../alacritty;
    ".config/git".source = ../git;
    ".config/nix-darwin".source = ../nix-darwin;
    ".config/nvim".source = ../nvim;
    ".config/ohmyposh".source = ../ohmyposh;
    ".config/zellij".source = ../zellij;
    ".zshenv".source = ../zsh/.zshenv;
    ".config/zsh/.zshrc".source = ../zsh/.zshrc;
    ".config/zsh/aliases".source = ../zsh/aliases;
    ".config/zsh/path".source = ../zsh/path;
  };
}

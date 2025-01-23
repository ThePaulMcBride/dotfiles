{ pkgs, ... }:
{

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  ##########################################################################

  environment.systemPackages = with pkgs; [
    alacritty
    bat
    capnproto
    cargo
    eza
    fd
    fnm
    fzf
    git
    go
    helix
    imagemagick
    lazydocker
    lazygit
    mise
    neovim
    nixfmt-rfc-style
    obsidian
    oh-my-posh
    protobuf
    ripgrep
    rustup
    stripe-cli
    yazi
    zellij
    zoxide
    zsh
    zsh-completions
  ];

  environment.variables.EDITOR = "nvim";

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    masApps = { };

    taps = [
      "homebrew/services"
    ];

    brews = [
      "helm"
      "helmfile"
    ];

    casks = [
      "1password"
      "brave-browser"
      "discord"
      "docker"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "postman"
      "raycast"
      "slack"
      "tableplus"
      "visual-studio-code"
      "zed"
      "zoom"
    ];
  };
}

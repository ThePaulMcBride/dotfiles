{ pkgs, ... }:
{

  config = {
    environment.systemPackages = with pkgs; [
      alacritty
      bat
      capnproto
      eza
      fd
      fnm
      fzf
      git
      go
      helix
      imagemagick
      jujutsu
      lazydocker
      lazygit
      neovim
      nixfmt

      protobuf
      ripgrep
      rustup
      starship
      stripe-cli
      tree-sitter
      yazi
      zellij
      zoxide
      zsh
      zsh-completions
    ];

    environment.variables.EDITOR = "nvim";
    environment.variables.HOMEBREW_NO_ANALYTICS = "1";
    environment.variables.HOMEBREW_NO_ENV_HINTS = "1";

    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };

      masApps = { };

      taps = [ "marcus/tap" ];

      brews = [
        "bacon"
        "marcus/tap/sidecar"
        "marcus/tap/td"
        "mise"
        "gh"
        "k9s"
        "tmux"
        "watch"
      ];

      casks = [
        "1password"
        "brave-browser"
        "cap"
        "discord"
        "docker-desktop"
        "firefox"
        "font-jetbrains-mono-nerd-font"
        "ghostty"
        "postman"
        "raycast"
        "slack"
        "tableplus"
        "visual-studio-code"
        "zed"
        "zen"
        "zoom"
        "obsidian"
      ];
    };
  };
}

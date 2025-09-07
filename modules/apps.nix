{ pkgs, ... }: {

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
      lazydocker
      lazygit
      neovim
      nixfmt-rfc-style
      obsidian
      protobuf
      ripgrep
      rustup
      starship
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

      taps = [ "homebrew/services" ];

      brews = [ "bacon" "mise" "gh" "k9s" "watch" ];

      casks = [
        "1password"
        "brave-browser"
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
      ];
    };
  };
}

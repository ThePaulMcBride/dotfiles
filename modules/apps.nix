{ pkgs, ... }:
{

  config = {
    environment.systemPackages = with pkgs; [
      alacritty
      bat
      capnproto
      delta
      difftastic
      eza
      fd
      fnm
      fzf
      git
      go
      helix
      imagemagick
      jujutsu
      kondo
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

    # Brew 6 enforces tap trust by default. Since `homebrew.taps` in this
    # config IS the trust assertion (git-reviewed), skip the redundant check
    # so taps don't have to be listed in two places.
    # FORCE_INSTALL_CLEANUP skips the interactive y/n prompt that
    # `brew bundle --cleanup` shows on every darwin-rebuild.
    environment.etc."homebrew/brew.env".text = ''
      HOMEBREW_NO_REQUIRE_TAP_TRUST=1
      HOMEBREW_BUNDLE_FORCE_INSTALL_CLEANUP=1
    '';

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
        "marcus/tap/td"
        "mise"
        "gh"
        "k9s"
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

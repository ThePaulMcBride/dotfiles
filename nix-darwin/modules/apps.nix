{ pkgs, specialArgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  ##########################################################################

  environment.systemPackages = with pkgs; [
    alacritty
    bat
    cargo
    eza
    obsidian
    fd
    fnm
    fzf
    git
    go
    helix
    imagemagick
    lazygit
    neovim
    nodejs_22
    oh-my-posh
    ripgrep
    stripe-cli
    yarn
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
    ];

    casks = [
      "1password"
      "brave-browser"
      "discord"
      "docker"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "postman"
      "raycast"
      "slack"
      "tableplus"
      "visual-studio-code"
      "zed"
      "zoom"
    ] ++ (if (specialArgs.host == "home") then [ "steam" ] else (if (specialArgs.host == "work") then [ "google-chrome" ] else [ ]));
  };
}

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    appimage-run
    azahar
    bat
    brave
    cemu
    eza
    fastfetch
    fzf
    gearlever
    gcc
    ghostty
    go
    git
    helix
    lazygit
    lact
    lutris
    mangohud
    melonDS
    mise
    mgba
    neovim
    nodejs
    oh-my-posh
    rustup
    ryubing
    steam-rom-manager
    unzip
    wl-clipboard
    yarn
    zellij
    zoxide
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "paul" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}

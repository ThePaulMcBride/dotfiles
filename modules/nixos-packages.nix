{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    adwsteamgtk
    alsa-scarlett-gui
    appimage-run
    azahar
    bat
    brave
    cemu
    discord
    docker
    eza
    fastfetch
    fluxcd
    fzf
    gearlever
    gcc
    ghostty
    go
    git
    # handbrake
    helix
    jujutsu
    just
    kind
    kubectl
    lazygit
    lact
    lsfg-vk
    lsfg-vk-ui
    lutris
    makemkv
    mangohud
    melonDS
    mise
    mgba
    neovim
    nodejs
    ollama-rocm
    opencode
    transmission_4-gtk
    rustup
    starship
    steam-rom-manager
    talosctl
    unzip
    wl-clipboard
    yarn
    yazi
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

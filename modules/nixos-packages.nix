{ pkgs, ... }:
let
  eden-emulator = pkgs.callPackage ../pkgs/eden-emulator.nix { };
  zelda64recomp = pkgs.callPackage ../pkgs/zelda64recomp.nix { };
  nvd-gen-diff =
    pkgs.writeShellScriptBin "nvd-gen-diff" (builtins.readFile ../scripts/nvd-gen-diff.sh);
in {
  environment.systemPackages = with pkgs; [
    adwsteamgtk
    alsa-scarlett-gui
    appimage-run
    azahar
    bat
    brave
    cemu
    discord
    eden-emulator
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
    # lutris
    # makemkv
    mangohud
    melonds
    mise
    mgba
    neovim
    nodejs
    nvd
    nvd-gen-diff
    ollama
    opencode
    transmission_4-gtk
    rustup
    starship
    steam-rom-manager
    stremio-linux-shell
    talosctl
    thunderbird
    unzip
    wl-clipboard
    yarn
    yazi
    zelda64recomp
    zellij
    zoxide
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [ hidapi ];
  };
  programs.gamemode.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "paul" ];
  };

  hardware = { steam-hardware = { enable = true; }; };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}

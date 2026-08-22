# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, user, ... }:
let
  azaharOverlay = final: prev: {
    azahar = prev.azahar.overrideAttrs (_: {
      version = "2126.0";
      src = prev.fetchurl {
        url = "https://github.com/azahar-emu/azahar/releases/download/2126.0/azahar-unified-source-2126.0.tar.xz";
        hash = "sha256-wnZEc/pGX4jzuMkO/VazqgpiRJGaSXQu60B/5CvYaag=";
      };
      sourceRoot = "azahar-unified-source-2126.0";
    });
  };
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos-hardware.nix
    ../../modules/nixos-services.nix
    ../../modules/nixos-packages.nix
    ../../modules/syncthing.nix
    ../../modules/fonts.nix
    ../../modules/gnome.nix
    ../../modules/kde.nix
    ../../modules/gc.nix
    ../../modules/openrgb.nix
    ../../modules/niri.nix
    ../../modules/docker.nix
    ../../modules/home-manager.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;
  nixpkgs.overlays = [ azaharOverlay ];

  networking.hostName = "argon"; # Define your hostname.
  networking.interfaces.eno1.wakeOnLan.enable = true;
  services.displayManager.defaultSession = lib.mkForce "plasma";
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;

  # Configure network proxy if necessary networking.proxy.default =
  # "http://user:password@proxy:port/"; networking.proxy.noProxy =
  # "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user.name} = {
    isNormalUser = true;
    description = user.fullName;
    extraGroups = [ "networkmanager" "wheel" "input" "uinput" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database
  # versions on your system were taken. It‘s perfectly fine and
  # recommended to leave this value at the release version of the first
  # install of this system. Before changing this value read the
  # documentation for this option (e.g. man configuration.nix or on
  # https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

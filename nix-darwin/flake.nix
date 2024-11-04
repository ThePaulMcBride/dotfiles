{
  description = "Paul's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
    let
      configuration = { pkgs, config, ... }: {
        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [
            pkgs.neovim
            pkgs.mkalias
            pkgs.alacritty
            pkgs.obsidian
            pkgs.fd
            pkgs.fnm
            pkgs.fzf
            pkgs.git
            pkgs.go
            pkgs.helix
            pkgs.imagemagick
            pkgs.lazygit
            pkgs.nodejs_22
            pkgs.oh-my-posh
            pkgs.ripgrep
            pkgs.stow
            pkgs.stripe-cli
            pkgs.tree
            pkgs.yarn
            pkgs.zellij
            pkgs.zoxide
            pkgs.zsh
            pkgs.zsh-completions
          ];

        homebrew = {
          enable = true;

          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;

          casks = [
            "1password"
            "brave-browser"
            "discord"
            "docker"
            "firefox"
            "postman"
            "raycast"
            "slack"
            "tableplus"
            "vscodium"
            "zed"
            "zoom"
          ];
          brews = [
            "stow"
          ];
        };

        fonts.packages =
          [
            (pkgs.nerdfonts.override {
              fonts = [ "JetBrainsMono" "Monaspace" ];
            })
          ];

        system.activationScripts.applications.text =
          let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            };
          in

          pkgs.lib.mkForce ''
            # Set up applications.
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

        users.users.paul.home = "/Users/paul";
        home-manager.backupFileExtension = "backup";
        nix.configureBuildUsers = true;
        nix.useDaemon = true;

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Pauls-MacBook-Pro
      darwinConfigurations."Pauls-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "paul";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.paul = import ./home.nix;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Pauls-MacBook-Pro".pkgs;
    };
}

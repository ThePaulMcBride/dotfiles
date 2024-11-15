{
  description = "Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, homebrew, ... }:
    let

      sharedModules = [
        # homebrew
        homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "paul";
          };
        }

        # home manager
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./home.nix;
        }

      ];

      username = "paul";
      useremail = "hello@paulmcbride.com";
      system = "aarch64-darwin";

      specialArgs =
        inputs
        // {
          inherit username useremail;
        };
    in
    {
      darwinConfigurations = {
        "home" = darwin.lib.darwinSystem {
          inherit system specialArgs;

          modules = [
            ./modules/nix-core.nix
            ./modules/system.nix
            ./modules/apps.nix
            ./modules/host-users.nix
            ./modules/home.nix
          ] ++ sharedModules;
        };

        "work" = darwin.lib.darwinSystem {
          inherit system specialArgs;

          modules = [
            ./modules/nix-core.nix
            ./modules/system.nix
            ./modules/apps.nix
            ./modules/host-users.nix
            ./modules/work.nix


          ] ++ sharedModules;
        };
      };
    };
}

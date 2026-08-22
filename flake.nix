{
  description = "Nix for macOS configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      catppuccin,
      darwin,
      home-manager,
      homebrew,
      ...
    }:
    let
      mkUser = homeRoot:
        let
          name = "paul";
        in {
          inherit name;
          fullName = "Paul McBride";
          email = "hello@paulmcbride.com";
          homeDirectory = "${homeRoot}/${name}";
        };
    in
    {
      nixosConfigurations = {
        "argon" = nixpkgs.lib.nixosSystem {
          specialArgs = inputs // {
            user = mkUser "/home";
          };
          system = "x86_64-linux";
          modules = [ ./hosts/argon ];
        };
      };

      darwinConfigurations = {
        "carbon" = darwin.lib.darwinSystem {
          specialArgs = inputs // {
            user = mkUser "/Users";
          };
          system = "aarch64-darwin";
          modules = [ ./hosts/carbon ];
        };

        "neon" = darwin.lib.darwinSystem {
          specialArgs = inputs // {
            user = mkUser "/Users";
          };
          system = "aarch64-darwin";
          modules = [ ./hosts/neon ];
        };
      };

      checks = {
        x86_64-linux = {
          argon = self.nixosConfigurations.argon.config.system.build.toplevel;
        };

        aarch64-darwin = {
          carbon = self.darwinConfigurations.carbon.system;
          neon = self.darwinConfigurations.neon.system;
        };
      };
    };
}

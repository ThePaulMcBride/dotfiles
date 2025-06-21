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
    nix-ld = {
      url = "github:nix-community/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      homebrew,
      ...
    }:
    let
      username = "paul";
      useremail = "hello@paulmcbride.com";

      specialArgs = inputs // {
        inherit username useremail;
      };
    in
    {
      nixosConfigurations = {
        "argon" = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./hosts/argon
            ./modules/home-manager.nix
            { programs.nix-ld.enable = true; }
          ];
        };
      };

      darwinConfigurations = {
        "carbon" = darwin.lib.darwinSystem {
          inherit specialArgs;
          system = "aarch64-darwin";
          modules = [ ./hosts/carbon ];
        };

        "neon" = darwin.lib.darwinSystem {
          inherit specialArgs;
          system = "aarch64-darwin";
          modules = [ ./hosts/neon ];
        };
      };
    };
}

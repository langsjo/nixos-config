{
  description = "Nixos config flake";

  outputs =
    { nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      optionDocs = pkgs.callPackage ./generate-docs.nix { };

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };

        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            ./hosts/desktop/configuration.nix
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

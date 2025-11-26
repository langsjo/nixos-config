{
  description = "Nixos config flake";

  outputs =
    { nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = func: lib.genAttrs systems (sys: func inputs.nixpkgs.legacyPackages.${sys});

      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
      optionDocs = forAllSystems (pkgs: pkgs.callPackage ./utils/generate-docs.nix { });
      packages = forAllSystems (pkgs: import ./packages { inherit inputs pkgs; });

      nixosConfigurations = {
        laptop = lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };

        desktop = lib.nixosSystem {
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

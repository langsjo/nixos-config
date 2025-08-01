{
  description = "Nixos config flake";

  outputs = _: { };
    # { nixpkgs, nixpkgs-unstable, ... }@inputs:
    # let
    #   system = "x86_64-linux";
    #   pkgs = nixpkgs.legacyPackages.${system};
    #   pkgs-unstable = import nixpkgs-unstable {
    #     inherit system;
    #     config.allowUnfree = true;
    #   };
    # in
    # {
    #   formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    #   optionDocs = pkgs.callPackage ./utils/generate-docs.nix { };
    #
    #   nixosConfigurations = {
    #     laptop = nixpkgs.lib.nixosSystem {
    #       specialArgs = {
    #         inherit inputs pkgs-unstable;
    #       };
    #
    #       modules = [
    #         ./hosts/laptop/configuration.nix
    #       ];
    #     };
    #
    #     desktop = nixpkgs.lib.nixosSystem {
    #       specialArgs = {
    #         inherit inputs pkgs-unstable;
    #       };
    #
    #       modules = [
    #         ./hosts/desktop/configuration.nix
    #       ];
    #     };
    #   };
    # };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

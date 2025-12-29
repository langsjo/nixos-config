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
        kehvatsu = lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs-unstable;
          };

          modules = [
            ./hosts/kehvatsu/configuration.nix
          ];
        };

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

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nixfmt
            sops
          ];
        };
      });
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

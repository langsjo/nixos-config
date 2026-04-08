{
  description = "Nixos config flake";

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = func: lib.genAttrs systems (sys: func inputs.nixpkgs.legacyPackages.${sys});
    in
    {
      nixosConfigurations = {
        kehvatsu = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/kehvatsu/configuration.nix ];
        };

        gorilla = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/gorilla/configuration.nix ];
        };

        desktop = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/desktop/configuration.nix ];
        };
      };

      homeConfigurations = {
        "langsjr1" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/l22-0167/home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
      packages = forAllSystems (pkgs: import ./packages { inherit pkgs inputs; });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nixfmt
            sops
          ];

          shellHook = ''
            if ! cmp --silent .git/hooks/pre-commit .pre-commit-hook.sh ; then 
              set -x
              install -Dm755 .pre-commit-hook.sh .git/hooks/pre-commit
              set +x
            fi
          '';
        };
      });
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-templates.url = "github:langsjo/flake-templates";
    wrapper-lib.url = "github:langsjo/wrapper-lib";
  };
}

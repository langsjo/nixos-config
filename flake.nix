{
  description = "Nixos config flake";

  outputs =
    { nixpkgs, ... }@inputs:
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

        laptop = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/laptop/configuration.nix ];
        };

        desktop = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/desktop/configuration.nix ];
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

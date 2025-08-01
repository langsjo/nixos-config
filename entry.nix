let
  inputs = import ./inputs.nix;
  inherit (inputs) nixpkgs nixpkgs-unstable;
  system = "x86_64-linux";
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  nixosConfigurations = {
    desktop = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs pkgs-unstable;
      };

      modules = [
        ./hosts/desktop/configuration.nix
      ];
    };
  };
}

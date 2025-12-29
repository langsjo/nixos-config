{
  inputs,
  pkgs,
}:
let
  lib = inputs.nixpkgs.lib;
  # Get the wrappers defined in the modules, then extract them to
  # be exposed from the flake
  evaledModules = lib.nixosSystem {
    modules = [
      ../modules
      {
        # Required so that any system can use these packages
        nixpkgs.hostPlatform = lib.mkForce pkgs.system;

        # Required to silence warnings
        system.stateVersion = "25.05";
      }
    ];

    specialArgs = {
      inherit inputs;
      pkgs-unstable = import inputs.nixpkgs {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };
in
lib.pipe evaledModules.config.wrappers [
  (lib.filterAttrs (_: wrapper: wrapper.expose))
  (builtins.mapAttrs (_: wrapper: wrapper.result))
]

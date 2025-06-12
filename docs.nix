let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;
  modules = lib.evalModules {
    modules = [
      ./modules
    ];
  };
in
pkgs.nixosOptionsDoc {
  inherit (modules) options;
}

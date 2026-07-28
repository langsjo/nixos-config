{
  pkgs,
  inputs,
}:
let
  callPackage = pkgs.newScope customPkgs;
  customPkgs = {
    rebuild = callPackage ./rebuild-script.nix { };
    showcerts = callPackage ./showcerts.nix { };
    nixpkgs-review-gha = callPackage ./nixpkgs-review-gha.nix { };
    neovim = import ./neovim { inherit pkgs inputs; };
    yubikey-oath-dmenu = pkgs.python3Packages.callPackage ./yubikey-oath-dmenu.nix { };
  }
  // (import ./wrappers { inherit pkgs inputs customPkgs; });
in
customPkgs

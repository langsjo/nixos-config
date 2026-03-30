{
  pkgs,
  inputs,
}:
{
  rebuild = pkgs.callPackage ./rebuild-script.nix { };
  nixpkgs-review-gha = pkgs.callPackage ./nixpkgs-review-gha.nix { };
  neovim = import ./neovim { inherit pkgs inputs; };
}
// (import ./wrappers { inherit pkgs inputs; })

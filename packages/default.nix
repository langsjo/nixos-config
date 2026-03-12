{
  pkgs,
  inputs,
}:
{
  rebuild = pkgs.callPackage ./rebuild-script.nix { };
  neovim = import ./neovim { inherit pkgs inputs; };
}
// (import ./wrappers { inherit pkgs inputs; })

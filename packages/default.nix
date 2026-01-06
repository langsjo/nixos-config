{
  pkgs,
  inputs,
}:
{
  rebuild = pkgs.callPackage ./rebuild-script.nix { };
}
// (import ./wrappers { inherit pkgs inputs; })

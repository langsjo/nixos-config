{
  pkgs,
}:
{
  rebuild = pkgs.callPackage ./rebuild-script.nix { };
}

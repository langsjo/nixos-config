{
  inputs,
  pkgs,
  ...
}:
{
  wrappers = import ./wrappers.nix { inherit inputs pkgs; };
  rebuild = pkgs.callPackage ./rebuild-script.nix { };
  nm2nix = pkgs.callPackage ./nm2nix.nix { };
}

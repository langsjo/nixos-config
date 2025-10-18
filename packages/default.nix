{
  inputs,
  pkgs,
  ...
}:
{
  wrappers = import ./wrappers.nix { inherit inputs pkgs; };
}

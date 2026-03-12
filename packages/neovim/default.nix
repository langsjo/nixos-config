{
  pkgs,
  inputs,
}:
let
  nixvim' = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  nixvimModule = {
    inherit pkgs;
    module = ./general.nix; # import the module directly
  };
in
nixvim'.makeNixvimWithModule nixvimModule

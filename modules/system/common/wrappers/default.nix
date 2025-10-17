{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;

  wrapperType = types.attrsOf (types.submodule (import ./wrapper-options.nix { inherit pkgs; }));
in
{
  options.wrappers = mkOption {
    description = "The wrappers to make";
    type = wrapperType;
    default = { };
  };

  config = {
    environment.systemPackages = lib.mkMerge (
      lib.mapAttrsToList (_: wrapper: lib.mkIf wrapper.install [ wrapper.result ]) config.wrappers
    );
  };
}

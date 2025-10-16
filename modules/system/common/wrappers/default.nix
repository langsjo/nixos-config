{
  config,
  lib,
  ...
}:
let
  cfg = config.wrappers;
  inherit (lib)
    mkOption
    types
    ;

  wrapperType = types.attrsOf (types.submodule (import ./wrapper-options.nix));
in
{
  options.wrappers = mkOption {
    description = "The wrappers to make";
    type = wrapperType;
    default = { };
  };
}

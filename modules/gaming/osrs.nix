{
  config,
  pkgs-unstable,
  lib,
  ...
}:
let
  cfg = config.custom.gaming.osrs;
in
{
  options.custom.gaming.osrs.enable = lib.mkOption {
    description = "Enable OSRS related configuration, such as Bolt launcher";
    type = lib.types.bool;
    default = config.custom.gaming.enable;
    defaultText = lib.literalExpression "config.custom.gaming.enable";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs-unstable.bolt-launcher
    ];
  };
}

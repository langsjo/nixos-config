{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gaming.light;
in
{
  options.custom.gaming.light.enable = lib.mkOption {
    description = "Whether to enable light gaming stuff";
    type = lib.types.bool;
    default = config.custom.caming.enable;
    defaultText = lib.literalExpression "config.custom.gaming.enable";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rmg
    ];
  };
}

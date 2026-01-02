{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.graphics;
in
{
  options.custom.hardware.graphics.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Whether to enable hardware accelerated graphis drivers";
    default = config.custom.gui.enable;
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}

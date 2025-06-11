{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.dm.ly;
in
{
  options.custom.dm.ly.enable = lib.mkEnableOption "Enable the ly display manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.ly.enable = true;
  };
}

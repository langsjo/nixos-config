{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gui.displayManager.ly;
in
{
  options.custom.gui.displayManager.ly.enable = lib.mkEnableOption "Enable the ly display manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.ly.enable = true;

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "ly cannot be enabled with gui disabled";
      }
    ];
  };
}

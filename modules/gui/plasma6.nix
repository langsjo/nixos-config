{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gui.desktopManager.plasma6;
in
{
  options.custom.gui.desktopManager.plasma6.enable =
    lib.mkEnableOption "Enable the Plasma 6 desktop environment";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "plasma6 cannot be enabled with gui disabled";
      }
    ];
  };
}

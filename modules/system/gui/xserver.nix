{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.xserver;
in
{
  options.custom.gui.xserver.enable = lib.mkEnableOption "Enable the X server";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;

    environment.systemPackages = with pkgs; [
      xsel
    ];

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "xserver cannot be enabled with gui disabled";
      }
    ];
  };
}

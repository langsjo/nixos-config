{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.bluetooth;
in
{
  options.custom.hardware.bluetooth.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    systemd.user.services.mpris-proxy = {
      wantedBy = [ "default.target" ];
    };
  };
}

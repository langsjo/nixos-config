{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.arr.jellyfin;
in
{
  options.custom.arr.jellyfin = {
    port = lib.mkOption {
      description = "jellyfin port";
      type = lib.types.port;
    };
    domain = lib.mkOption {
      description = "jellyfin domain";
      type = lib.types.str;
    };
    hwAccDev = lib.mkOption {
      description = "device for hardware acceleration";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.custom.arr.enable {
    hardware.graphics.enable = true;
    services = {
      jellyfin = {
        enable = true;
        openFirewall = false;
        hardwareAcceleration = {
          enable = true;
          device = cfg.hwAccDev;
        };
      };
    };
    systemd.services.jellyfin = config.custom.arr.wireguard.netnsConfig;
    custom.arr.wireguard.netnsProxies."jellyfin" = cfg.port;
    custom.intraWebsites.${cfg.domain} = cfg.port;
  };
}

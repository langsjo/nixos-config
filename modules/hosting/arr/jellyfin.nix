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
    users.users.${config.services.jellyfin.user}.extraGroups = [ "media" ];

    services = {
      jellyfin = {
        enable = true;
        openFirewall = false;
        hardwareAcceleration = {
          enable = true;
          device = cfg.hwAccDev;
        };
      };

      caddy.virtualHosts = {
        ${cfg.domain} = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:${toString cfg.port}
          '';
          useACMEHost = cfg.domain;
        };
      };
    };
    systemd.services.jellyfin = config.custom.arr.wireguard.netnsConfig;
    custom.arr.wireguard.netnsProxies."jellyfin" = cfg.port;
    custom.certs.dns01Domains.${cfg.domain} = {
      domains = [ cfg.domain ];
      group = "caddy";
    };
  };
}

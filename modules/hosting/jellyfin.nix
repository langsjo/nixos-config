{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.jellyfin;
in
{
  options.custom.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
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

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    users.users.${config.services.jellyfin.user}.extraGroups = [ "qbittorrent" ];
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
    custom.certs.dns01Domains.${cfg.domain} = {
      domains = [ cfg.domain ];
      group = "caddy";
    };
  };
}

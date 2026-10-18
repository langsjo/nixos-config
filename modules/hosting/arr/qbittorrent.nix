{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.arr.qbittorrent;
  ns = config.custom.arr.wireguard.ns;
in
{
  options.custom.arr.qbittorrent = {
    webUIPort = lib.mkOption {
      description = "qbittorrent webui port";
      type = lib.types.port;
    };
    webUIDomain = lib.mkOption {
      description = "domain for webui";
      type = lib.types.str;
    };
    torrentPort = lib.mkOption {
      description = "qbittorrent torrenting port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf config.custom.arr.enable {

    systemd.tmpfiles.rules = [
      "d /srv/torrents 2750 ${config.services.qbittorrent.user} media -"
    ];
    custom.user.extraGroups = [ config.services.qbittorrent.group ];

    services.qbittorrent = {
      enable = true;
      webuiPort = cfg.webUIPort;
      torrentingPort = cfg.torrentPort;
      openFirewall = false;
    };
    custom.arr.wireguard = {
      allowedTCPPorts = [ cfg.torrentPort ];
      allowedUDPPorts = [ cfg.torrentPort ];
    };

    systemd.services.qbittorrent = lib.mkMerge [
      config.custom.arr.wireguard.netnsConfig
      {
        serviceConfig.UMask = "0002"; # allow group to write
      }
    ];

    custom.intraWebsites.${cfg.webUIDomain} = cfg.webUIPort;
    custom.arr.wireguard.netnsProxies."qbittorrent" = cfg.webUIPort;
  };
}

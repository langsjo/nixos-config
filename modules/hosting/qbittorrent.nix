{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.qbittorrent;
  ns = "air-qbit";
  ip = "${pkgs.iproute2}/bin/ip";

  resolvFile = pkgs.writeText "airvpn-resolv.conf" ''
    nameserver 10.128.0.1
  '';
in
{
  options.custom.qbittorrent = {
    enable = lib.mkEnableOption "qbittorrent";
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

  config = lib.mkIf cfg.enable {

    sops.secrets = {
      "airvpn-sk" = { };
      "airvpn-psk" = { };
    };
    networking.wireguard.interfaces.${ns} = {
      interfaceNamespace = ns;
      preSetup = ''
        ${ip} netns add ${ns} || true
        ${ip} -n ${ns} link set lo up
      '';
      postShutdown = ''
        ${ip} netns del ${ns} || true
      '';
      ips = [
        "10.134.19.34/32"
        "fd7d:76ee:e68f:a993:99b3:a9dd:80bf:b2e1/128"
      ];
      privateKeyFile = config.sops.secrets."airvpn-sk".path;
      mtu = 1320;

      peers = [
        {
          publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          presharedKeyFile = config.sops.secrets."airvpn-psk".path;
          endpoint = "europe3.vpn.airdns.org:1637";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          persistentKeepalive = 15;
          dynamicEndpointRefreshSeconds = 300;
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d /srv/torrents 2750 ${config.services.qbittorrent.user} ${config.services.qbittorrent.group} -"
    ];
    custom.user.extraGroups = [ config.services.qbittorrent.group ];

    services.qbittorrent = {
      enable = true;
      webuiPort = cfg.webUIPort;
      torrentingPort = cfg.torrentPort;
      openFirewall = false;
    };

    systemd.services.qbittorrent = {
      bindsTo = [ "wireguard-${ns}.service" ];
      after = [ "wireguard-${ns}.service" ];
      partOf = [ "wireguard-${ns}.service" ];
      serviceConfig = {
        NetworkNamespacePath = "/run/netns/${ns}";
        BindReadOnlyPaths = [ "${resolvFile}:/etc/resolv.conf" ];
        InaccessiblePaths = [
          "-/run/nscd"
          "-/run/systemd/resolve"
        ];
      };
    };

    custom.certs.dns01Domains.${cfg.webUIDomain} = {
      domains = [ cfg.webUIDomain ];
      group = "caddy";
    };
    services.caddy.virtualHosts = {
      ${cfg.webUIDomain} = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString cfg.webUIPort}
        '';
        useACMEHost = cfg.webUIDomain;
      };
    };

    systemd.sockets.qbittorrent-proxy = {
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "127.0.0.1:${toString cfg.webUIPort}" ];
    };

    systemd.services.qbittorrent-proxy = {
      requires = [ "qbittorrent.service" ];
      after = [ "qbittorrent.service" ];
      partOf = [ "qbittorrent.service" ];

      serviceConfig = {
        ExecStart = ''
          ${config.systemd.package}/lib/systemd/systemd-socket-proxyd 127.0.0.1:${toString cfg.webUIPort}
        '';
        NetworkNamespacePath = "/run/netns/${ns}";
      };
    };
  };
}

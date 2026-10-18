{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.arr.wireguard;
  ip = "${pkgs.iproute2}/bin/ip";
  resolvConf = pkgs.writeText "wg-resolv.conf" ''
    nameserver 10.128.0.1
  '';
in
{
  options.custom.arr.wireguard = {
    ns = lib.mkOption {
      description = "name for the wireguard netns";
      type = lib.types.str;
      default = "arr-ns";
    };

    netnsProxies = lib.mkOption {
      description = "systemd services to proxy traffic to";
      type = with lib.types; attrsOf port;
    };

    netnsConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {
        bindsTo = [ "wireguard-${cfg.ns}.service" ];
        after = [ "wireguard-${cfg.ns}.service" ];

        serviceConfig = {
          NetworkNamespacePath = "/run/netns/${cfg.ns}";
          BindReadOnlyPaths = [ "${resolvConf}:/etc/resolv.conf" ];
          InaccessiblePaths = [
            "-/run/nscd"
            "-/run/systemd/resolve"
          ];
        };
      };
      internal = true;
      readOnly = true;
    };
  };

  config = lib.mkIf config.custom.arr.enable {
    sops.secrets = {
      "airvpn-sk" = {
        sopsFile = ../../secrets/gorilla/default.yaml;
      };
      "airvpn-psk" = {
        sopsFile = ../../secrets/gorilla/default.yaml;
      };
    };
    networking.wireguard.interfaces.${cfg.ns} = {
      interfaceNamespace = cfg.ns;
      preSetup = ''
        ${ip} netns add ${cfg.ns} || true
        ${ip} -n ${cfg.ns} link set lo up
      '';
      postShutdown = ''
        ${ip} netns del ${cfg.ns} || true
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
          endpoint = "79.142.77.189:1637";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          persistentKeepalive = 15;
          dynamicEndpointRefreshSeconds = 300;
        }
      ];
    };

    systemd = lib.mkMerge (
      lib.mapAttrsToList (name: port: {
        sockets."${name}-proxy" = {
          wantedBy = [
            "sockets.target"
            "${name}.service"
          ];
          partOf = [ "${name}.service" ];
          listenStreams = [ "127.0.0.1:${toString port}" ];
        };
        services."${name}-proxy" = lib.mkMerge [
          cfg.netnsConfig
          {
            bindsTo = [ "${name}.service" ];
            after = [ "${name}.service" ];

            serviceConfig.ExecStart = ''
              ${config.systemd.package}/lib/systemd/systemd-socket-proxyd 127.0.0.1:${toString port}
            '';
          }
        ];
      }) cfg.netnsProxies
    );
  };
}

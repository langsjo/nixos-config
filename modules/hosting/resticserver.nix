{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.resticServer;
in
{
  options.custom.resticServer = {
    enable = lib.mkEnableOption "hosting a restic REST server";
    domain = lib.mkOption {
      description = "restic server domain";
      type = lib.types.str;
    };
    port = lib.mkOption {
      description = "restic server port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."restic_server_htpasswd" = {
      sopsFile = ../secrets/gorilla/restic_server_htpasswd;
      owner = "restic";
      format = "binary";
    };

    services.restic.server = {
      enable = true;
      dataDir = "/mnt/backup";
      listenAddress = toString cfg.port;
      htpasswd-file = config.sops.secrets."restic_server_htpasswd".path;
      privateRepos = true;
    };

    custom.certs.intraDomains = [ cfg.domain ];
    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      useACMEHost = "intra.gorilla.gay";
      # Only reachable from Tailscale or the local network.
      extraConfig = ''
        allow 100.64.0.0/10;       # Tailscale/headscale IPv4 (CGNAT range)
        allow fd7a:115c:a1e0::/48; # Tailscale/headscale IPv6
        allow 192.168.1.0/24;      # LAN
        deny all;
      '';
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.port}";
        extraConfig = ''
          client_max_body_size 150M;
        '';
      };
    };
  };
}

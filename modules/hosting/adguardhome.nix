{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.adguardhome;
in
{
  options.custom.adguardhome = {
    enable = lib.mkEnableOption "hosting adguardhome";
    httpPort = lib.mkOption {
      description = "webui http port";
      type = lib.types.port;
    };
    httpsPort = lib.mkOption {
      description = "webui https port";
      type = lib.types.port;
    };
    domain = lib.mkOption {
      description = "adguard server domain";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      openFirewall = false;
      host = "100.64.0.2";
      port = cfg.httpPort;

      settings = {
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
          ratelimit = 0;
          upstream_dns = [
            "1.1.1.1"
          ];
          fallback_dns = [
            "8.8.8.8"
          ];
          bootstrap_dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];

          cache_enabled = true;
          cache_size = 1024 * 1024 * 100; # 100 MiB
        };

        tls = {
          enabled = true;
          server_name = cfg.domain;
          port_https = cfg.httpsPort;
          force_https = true;
          port_dns_over_tls = 853;
          certificate_path = "/var/lib/acme/${cfg.domain}/fullchain.pem";
          private_key_path = "/var/lib/acme/${cfg.domain}/key.pem";
        };
      };
    };
    custom.certs.dns01Domains.${cfg.domain} = {
      domains = [ cfg.domain ];
      group = "adguardhome-cert";
    };
    users.groups."adguardhome-cert" = { };
    systemd.services."adguardhome".serviceConfig.SupplementaryGroups = [ "adguardhome-cert" ];
    networking.firewall = {
      allowedUDPPorts = [ 53 ]; # basic DNS
      allowedTCPPorts = [ 853 ]; # DNS over TLS
    };
  };
}

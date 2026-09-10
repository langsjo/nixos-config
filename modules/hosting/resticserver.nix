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
      listenAddress = "100.64.0.2:${toString cfg.port}";
      htpasswd-file = config.sops.secrets."restic_server_htpasswd".path;
      privateRepos = true;
      extraFlags = [
        "--tls"
        "--tls-cert"
        "/var/lib/acme/${cfg.domain}/fullchain.pem"
        "--tls-key"
        "/var/lib/acme/${cfg.domain}/key.pem"
      ];
    };

    custom.certs.dns01Domains.${cfg.domain} = {
      domains = [ cfg.domain ];
      group = "restic";
    };
  };
}

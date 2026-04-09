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

    custom.dyndns.domains = [ cfg.domain ];
    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.port}";
        extraConfig = ''
          client_max_body_size 150M;
        '';
      };
    };
  };
}

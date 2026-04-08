{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.attic;
in
{
  options.custom.attic = {
    enable = lib.mkEnableOption "hosting attic cache";
    domain = lib.mkOption {
      description = "attic domain";
      type = lib.types.str;
    };
    port = lib.mkOption {
      description = "attic port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."attic-server-token" = {
        sopsFile = ../secrets/gorilla/default.yaml;
      };
      templates."attic-envfile" = {
        # owner = config.services.atticd.user;
        content = ''
          ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder."attic-server-token"}
        '';
      };
    };
    services.atticd = {
      enable = true;
      environmentFile = config.sops.templates."attic-envfile".path;
      settings = {
        listen = "[::]:${toString cfg.port}";
        allowed-hosts = [ cfg.domain ];
        api-endpoint = "https://${cfg.domain}/";
        database.url = "postgresql://${config.services.atticd.user}?host=/run/postgresql";

        garbage-collection = {
          interval = "24 hours";
          default-retention-period = "3 months";
        };
      };
    };
    services.nginx = {
      virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          extraConfig = ''
            client_max_body_size 0;
          '';
        };
      };
    };

    custom.dyndns.domains = [ cfg.domain ];

    services.postgresql = {
      enable = true;
      ensureDatabases = [ config.services.atticd.user ];
      ensureUsers = [
        {
          name = config.services.atticd.user;
          ensureDBOwnership = true;
        }
      ];
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.attic;
  port = 9874;
  host = "cache.gorilla.gay";
in
{
  options.custom.attic.enable = lib.mkEnableOption "hosting attic cache";

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."attic-server-token" = {
        sopsFile = ../secrets/homelab/default.yaml;
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
        listen = "[::]:${toString port}";
        allowed-hosts = [ host ];
        api-endpoint = "https://${host}/";
        database.url = "postgresql://${config.services.atticd.user}?host=/run/postgresql";

        garbage-collection = {
          interval = "24 hours";
          default-retention-period = "3 months";
        };
      };
    };
    services.nginx = {
      enable = true;
      virtualHosts.${host} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString port}";
          extraConfig = ''
            client_max_body_size 0;
          '';
        };
      };
    };

    custom.dyndns.domains = [ host ];

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

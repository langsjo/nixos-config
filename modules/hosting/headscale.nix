{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.headscale;
in
{
  options.custom.headscale = {
    enable = lib.mkEnableOption "hosting headscale";
    domain = lib.mkOption {
      description = "headscale domain";
      type = lib.types.str;
    };
    port = lib.mkOption {
      description = "headscale port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    services.headscale = {
      enable = true;
      inherit (cfg) port;
      settings = {
        serverUrl = "https://${cfg.domain}";
        dns = {
          magic_dns = true;
          override_local_dns = true;
          base_domain = "gorillanet";
          nameservers.global = [
            "100.64.0.2"
          ];
        };
        policy.path = pkgs.writeText "headscale-policies" (
          builtins.toJSON {
            tagOwners = {
              "tag:gorilla" = [ ];
              "tag:kehvatsu" = [ ];
              "tag:phone" = [ ];
              "tag:vimpula" = [ ];
            };
            acls = [
              {
                action = "accept";
                src = [
                  "tag:phone"
                  "tag:kehvatsu"
                ];
                dst = [ "tag:gorilla:*" ];
              }
              {
                action = "accept";
                src = [ "tag:phone" ];
                dst = [ "tag:kehvatsu:*" ];
              }
              {
                action = "accept";
                src = [
                  "tag:phone"
                  "tag:gorilla"
                  "tag:kehvatsu"
                ];
                dst = [ "tag:vimpula:*" ];
              }
              {
                action = "accept";
                src = [ "tag:vimpula" ];
                dst = [ "tag:kehvatsu:37730" ];
              }
              {
                action = "accept";
                src = [ "tag:vimpula" ];
                dst = [ "tag:gorilla:${toString config.custom.cliproxyapi.port}" ];
              }
            ];
          }
        );
      };
    };

    custom.dyndns.domains = [ cfg.domain ];

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}

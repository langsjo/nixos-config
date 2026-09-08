{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.certs;
in
{
  options.custom.certs = {
    enable = lib.mkEnableOption "creating certs with acme";
    dns01Domains = lib.mkOption {
      description = "Domains to get certs under the intra domain";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            domains = lib.mkOption {
              description = "the domains this cert has";
              type = with lib.types; listOf str;
            };
            group = lib.mkOption {
              description = "the group that has access to the key";
              type = lib.types.str;
            };
          };
        }
      );
      default = { };
      example = {
        "mycert.example.com" = {
          domains = [ "mycert.example.com" ];
          group = "nginx";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."cloudflare-api-token" = {
        sopsFile = ../secrets/gorilla/default.yaml;
      };
      templates."acme-cloudflare-envfile" = {
        owner = "acme";
        content = ''
          CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare-api-token"}
        '';
      };
    };
    security.acme = {
      acceptTerms = true;
      certs = builtins.mapAttrs (k: v: {
        environmentFile = config.sops.templates."acme-cloudflare-envfile".path;
        extraDomainNames = v.domains;
        dnsProvider = "cloudflare";
        group = v.group;
      }) cfg.dns01Domains;
    };
  };
}

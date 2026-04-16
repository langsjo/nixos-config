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
    intraDomains = lib.mkOption {
      description = "Domains to get certs under the intra domain";
      type = with lib.types; listOf str;
      default = [ ];
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
      certs."intra.gorilla.gay" = {
        environmentFile = config.sops.templates."acme-cloudflare-envfile".path;
        extraDomainNames = cfg.intraDomains;
        dnsProvider = "cloudflare";
        group = "nginx";
      };
    };
  };
}

{
  config,
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
          base_domain = "gorillanet";
          nameservers.global = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
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

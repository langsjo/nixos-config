{
  config,
  lib,
  ...
}:
{
  options.custom.intraWebsites = lib.mkOption {
    description = "services to only host internally behind tailscale via caddy";
    type = with lib.types; attrsOf port;
    default = { };
  };
  config = {
    services.caddy = {
      enable = true;
      globalConfig = ''
        default_bind 100.64.0.2
        auto_https disable_certs
      '';
      virtualHosts = lib.mapAttrs (domain: port: {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString port}
        '';
        useACMEHost = domain;
      }) config.custom.intraWebsites;
    };
    custom.certs.dns01Domains = lib.mapAttrs (domain: _: {
      domains = [ domain ];
      group = "caddy";
    }) config.custom.intraWebsites;

    # allow restarting in case tailscale is not yet up to bind to ip
    systemd.services.caddy = {
      unitConfig = {
        StartLimitIntervalSec = lib.mkForce "0s";
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
        RestartMaxDelaySec = "5min";
        RestartSteps = 10;
      };
    };
  };
}

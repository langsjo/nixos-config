{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.intrasites;
in
{
  options.custom.intrasites = {
    enable = lib.mkEnableOption "using caddy to serve intra websites";
    bindIP = lib.mkOption {
      description = "the IP address to bind caddy to";
      type = lib.types.str;
    };
    sites = lib.mkOption {
      description = "services to only host internally behind tailscale via caddy";
      type = with lib.types; attrsOf port;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      globalConfig = ''
        default_bind ${cfg.bindIP}
        auto_https disable_certs
      '';
      virtualHosts = lib.mapAttrs (domain: port: {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString port}
        '';
        useACMEHost = domain;
      }) cfg.sites;
    };

    custom.certs = {
      enable = true;
      dns01Domains = lib.mapAttrs (domain: _: {
        domains = [ domain ];
        group = "caddy";
      }) cfg.sites;
    };

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

{
  config,
  lib,
  pkgs,
  myPkgs,
  ...
}:
let
  cfg = config.custom.cliproxyapi;
in
{
  options.custom.cliproxyapi = {
    enable = lib.mkEnableOption "hosting CLIProxyAPI";
    domain = lib.mkOption {
      description = "CLIProxyAPI domain";
      type = lib.types.str;
    };
    port = lib.mkOption {
      description = "CLIProxyAPI port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets =
      lib.genAttrs [ "cliproxyapi-t3jail-key" "cliproxyapi-vimpula-key" "cliproxyapi-management-key" ]
        (_: {
          sopsFile = ../secrets/gorilla/cliproxyapi.yaml;
        });

    services.cliproxyapi = {
      enable = true;
      settings = {
        config-version = 8;
        server = {
          host = "0.0.0.0";
          inherit (cfg) port;
          trusted-proxies = [ "127.0.0.1" ];
        };
        routing = {
          strategy = "round-robin";
          session-afinity = true;
          session-afinity-ttl = "1h";
        };
        access.api-keys = [
          { _secret = config.sops.secrets."cliproxyapi-vimpula-key".path; }
          { _secret = config.sops.secrets."cliproxyapi-t3jail-key".path; }
        ];
        management = {
          allow-remote = true;
          secret-key._secret = config.sops.secrets."cliproxyapi-management-key".path;
        };
        plugins = {
          enabled = true;
          dir = myPkgs.mistral-bridge;
          # mistral keys and model mappings are managed in its console at
          # /v0/resource/plugins/mistral-bridge/console
          configs.mistral-bridge.enabled = true;
        };
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "cliproxyapi-wrapped" ''
        exec sudo -u ${config.services.cliproxyapi.user} ${lib.getExe config.services.cliproxyapi.package} -config /var/lib/cliproxyapi/config.yaml "$@"
      '')
    ];

    custom.intrasites.sites.${cfg.domain} = cfg.port;
    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      rewrite / /management.html
    '';
  };
}

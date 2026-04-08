{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.dyndns;
in
{
  options.custom.dyndns = {
    enable = lib.mkEnableOption "cloudflare dynamic dns";
    domains = lib.mkOption {
      description = "domains for dynamic dns";
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."cloudflare-api-token" = {
      sopsFile = ../secrets/gorilla/default.yaml;
    };
    services.cloudflare-dyndns = {
      enable = true;
      inherit (cfg) domains;
      apiTokenFile = config.sops.secrets."cloudflare-api-token".path;
    };
  };
}

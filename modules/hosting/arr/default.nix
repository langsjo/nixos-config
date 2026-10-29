{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.arr;
  netnsConfig = config.custom.arr.wireguard.netnsConfig;
  mkOptions = serviceName: {
    port = lib.mkOption {
      description = "port for ${serviceName}";
      type = lib.types.port;
    };
    domain = lib.mkOption {
      description = "domain for ${serviceName}";
      type = lib.types.str;
    };
  };
  mkArrSettings = port: {
    server = {
      inherit port;
      bindaddress = "127.0.0.1";
    };
    auth = {
      method = "Forms";
      required = "Enabled";
    };
    log.analyticsEnabled = false;
    update = {
      mechanism = "external";
      automatically = false;
    };
  };
in
{
  imports = [
    ./jellyfin.nix
    ./qbittorrent.nix
    ./wireguard.nix
  ];
  options.custom.arr = {
    enable = lib.mkEnableOption "hosting arr stack";
    sonarr = mkOptions "sonarr";
    radarr = mkOptions "radarr";
    prowlarr = mkOptions "prowlarr";
    bazarr = mkOptions "bazarr";
  };

  config = lib.mkIf cfg.enable {
    users.groups.media = { };
    custom.user.extraGroups = [ "media" ];
    systemd.tmpfiles.rules = [
      "d /srv/media 2775 root media -"
    ];
    services = {
      sonarr = {
        enable = true;
        openFirewall = false;
        settings = mkArrSettings cfg.sonarr.port;
      };
      radarr = {
        enable = true;
        openFirewall = false;
        settings = mkArrSettings cfg.radarr.port;
      };
      prowlarr = {
        enable = true;
        openFirewall = false;
        settings = mkArrSettings cfg.prowlarr.port;
      };
      bazarr = {
        enable = true;
        group = "media";
        settings = {
          general = {
            inherit (cfg.bazarr) port;
            ip = "127.0.0.1";
            use_sonarr = true;
            use_radarr = true;
          };
          analytics.enabled = false;
          sonarr = {
            ip = "127.0.0.1";
            port = cfg.sonarr.port;
          };
          radarr = {
            ip = "127.0.0.1";
            port = cfg.radarr.port;
          };
        };
      };
    };

    # Need write access to /srv/media
    users.users.sonarr.extraGroups = [ "media" ];
    users.users.radarr.extraGroups = [ "media" ];

    systemd.services = {
      sonarr = lib.mkMerge [
        netnsConfig
        { serviceConfig.UMask = lib.mkForce "0002"; }
      ];
      radarr = lib.mkMerge [
        netnsConfig
        { serviceConfig.UMask = lib.mkForce "0002"; }
      ];
      bazarr = lib.mkMerge [
        netnsConfig
        { serviceConfig.UMask = lib.mkForce "0002"; }
      ];
      prowlarr = netnsConfig;
    };

    custom.intrasites.sites = lib.genAttrs' [ "prowlarr" "radarr" "sonarr" "bazarr" ] (
      name: lib.nameValuePair cfg.${name}.domain cfg.${name}.port
    );

    custom.arr.wireguard.netnsProxies = {
      sonarr = cfg.sonarr.port;
      radarr = cfg.radarr.port;
      prowlarr = cfg.prowlarr.port;
      bazarr = cfg.bazarr.port;
    };
  };
}

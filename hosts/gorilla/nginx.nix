{
  config,
  pkgs,
  ...
}:
let
  robotsTxt = pkgs.writeText "robots.txt" ''
    User-agent: *
    Disallow: /files
  '';
in
{
  custom.dyndns.domains = [
    "langsjo.dev"
    "ip.langsjo.dev"
  ];
  services.nginx = {
    enable = true;
    defaultListenAddresses = [
      "192.168.1.10"
      "[::0]"
    ];

    virtualHosts = {
      "_" = {
        rejectSSL = true;
        default = true;
        locations."/" = {
          return = "404";
        };
      };
      "langsjo.dev" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            return = "302 /";
          };
          "= /" = {
            return = ''
              200
              "gorilloidaan\n${config.custom.user.pgpKey.fingerprint}"
            '';
            extraConfig = ''
              add_header Content-Type text/plain;
            '';
          };
          "= /pgp.asc" = {
            alias = config.custom.user.pgpKey.file;
            extraConfig = ''
              default_type application/pgp-keys;
            '';
          };
          "= /robots.txt" = {
            alias = robotsTxt;
            extraConfig = ''
              default_type text/plain;
            '';
          };
          "/files/" = {
            alias = "/srv/nginx-public/";
            extraConfig = ''
              add_header X-Robots-Tag "noindex, nofollow" always;
            '';
          };
        };
      };

      "ip.langsjo.dev" = {
        enableACME = true;
        addSSL = true;
        locations."/" = {
          return = ''200 "$remote_addr\n"'';
          extraConfig = ''
            add_header Content-Type text/plain;
          '';
        };
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /srv/nginx-public 0755 ${config.custom.user.username} ${config.services.nginx.group} -"
  ];
}

{
  config,
  ...
}:
{
  custom.dyndns.domains = [
    "gorilla.gay"
    "ip.gorilla.gay"
  ];
  services.nginx = {
    enable = true;
    virtualHosts = {
      "_" = {
        rejectSSL = true;
        default = true;
        locations."/" = {
          return = "404";
        };
      };
      "gorilla.gay" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
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
        };
      };

      "ip.gorilla.gay" = {
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
}

{
  security.acme.acceptTerms = true;
  custom.dyndns.domains = [
    "gorilla.gay"
    "ip.gorilla.gay"
  ];
  services.nginx = {
    enable = true;
    virtualHosts = {
      "gorilla.gay" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = ''200 "gorilloidaan\n"'';
          extraConfig = ''
            add_header Content-Type text/plain;
          '';
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

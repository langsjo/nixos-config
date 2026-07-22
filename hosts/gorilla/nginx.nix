{
  pkgs,
  ...
}:
let
  pgpPubKey = pkgs.writeText "pgp-pub-key" ''
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    mDMEal/POhYJKwYBBAHaRw8BAQdAvpyJ6iwO585a3kNI/9j+LLJKJ2AHH8rR1zYy
    +8NFnrO0B2xhbmdzam+IjgQTFgoANhYhBL8aQVHy4l5vksNSfJMs+VjwIqFLBQJq
    X886AhsBBAsJCAcEFQoJCAUWAgMBAAIeAQIXgAAKCRCTLPlY8CKhSySkAP0beTKo
    NicPstKxOWAGiOPqIWIiIqaVQQRmAsson0K8AgEA02Epfs8wqV1tQ+TV4je87uHG
    DXl9eYsNTYHninINEQq4MwRqX9BmFgkrBgEEAdpHDwEBB0CzXPi5j5HsfNQkLvzk
    47vDbL/YJtvxxZbSoPEhnNflRoj1BBgWCgAmAhsCFiEEvxpBUfLiXm+Sw1J8kyz5
    WPAioUsFAmpf0S4FCQWjm0gAgXYgBBkWCgAdFiEEJY8KW0mPw5epHFOsOxzBtOiP
    ZCkFAmpf0GYACgkQOxzBtOiPZCl55AEAud+LoDna/r992ZL7mGDfjdoNOBYuhdb5
    5gziYImjUxkA/ArzPUPZklefdi5+Qz9ZXUCObpM3tMotOv50McHi1icFCRCTLPlY
    8CKhSzD6AQCH7k/Y4Z++iYtR7bXdtO68pszOM4BDQkVklEUxh7ue0AEA+3lN+2VA
    XOKduMXT4G12mJ5EF9IVOc2I+yCL192BUwC4OARqX9CTEgorBgEEAZdVAQUBAQdA
    UR9994nl5YEg99Btd4uTixMHKbNTb0+Cu85xIQDvp2sDAQgHiH4EGBYKACYCGwwW
    IQS/GkFR8uJeb5LDUnyTLPlY8CKhSwUCal/RTgUJBaObGwAKCRCTLPlY8CKhS5Px
    AP9buzjpBj9mFF6y/AWZNokOQxPnxIx/6YAoTYFw0wWGhgEA9NodZWigs2drdqQn
    hF6bf5+TedqNrh4FAO7ElZJnwQG4MwRqX9CpFgkrBgEEAdpHDwEBB0BLbRAVTxqa
    /NB49ECew4kFUMPEsju6xVtABNCmGmXH6Ih+BBgWCgAmAhsgFiEEvxpBUfLiXm+S
    w1J8kyz5WPAioUsFAmpf0U4FCQWjmwUACgkQkyz5WPAioUtD4AD+PKrbguhkWiQr
    w8NkXtTX3NX946CycXnhg89dbQea8wMBAMZ+WUk/L/EOjUoce0bEdE/+0SkDWr9H
    QA2CL8pUdyUF
    =MqEF
    -----END PGP PUBLIC KEY BLOCK-----
  '';
in
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
              "gorilloidaan\nBF1A 4151 F2E2 5E6F 92C3  527C 932C F958 F022 A14B"
            '';
            extraConfig = ''
              add_header Content-Type text/plain;
            '';
          };
          "= /pgp.asc" = {
            alias = pgpPubKey;
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

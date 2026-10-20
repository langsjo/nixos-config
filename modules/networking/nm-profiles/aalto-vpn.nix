# setup taken from https://github.com/z10n-dev/nixos-anyconnect-webauth/blob/main/vpn.nix
let
  gateway = "vpn1.aalto.fi";
in
{
  networking.networkmanager.ensureProfiles.profiles = {
    "Aalto VPN" = {
      connection = {
        id = "Aalto VPN";
        type = "vpn";
      };
      vpn = {
        inherit gateway;
        useragent = "AnyConnect";
        cookie-flags = 2;
        protocol = "anyconnect";
        service-type = "org.freedesktop.NetworkManager.openconnect";
      };
      vpn-secrets = {
        inherit gateway;
        gwcert = "";
      };
    };
  };
}

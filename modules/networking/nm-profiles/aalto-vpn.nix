{
  networking.networkmanager.ensureProfiles.profiles = {
    "Aalto VPN" = {
      connection = {
        id = "Aalto VPN";
        type = "vpn";
      };
      vpn = {
        gateway = "vpn1.aalto.fi";
        protocol = "anyconnect";
        useragent = "AnyConnect-compatible OpenConnect VPN agent";
      };
    };
  };
}

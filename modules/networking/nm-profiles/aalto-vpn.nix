{
  networking.networkmanager.ensureProfiles.profiles = {
    "Aalto VPN" = {
      connection = {
        id = "Aalto VPN";
        type = "vpn";
      };
      vpn = {
        gateway = "vpn1.aalto.fi";
        useragent = "AnyConnect-compatible OpenConnect VPN agent";
        cookie-flags = 2;
        service-type = "org.freedesktop.NetworkManager.openconnect";
      };
    };
  };
}

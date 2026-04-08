{
  networking = {
    firewall.allowedTCPPorts = [
      80
      443
    ];
    hostName = "gorilla";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    networkmanager.ensureProfiles.profiles."zyxel" = {
      ipv4 = {
        method = "manual";
        addresses = "192.168.1.10/24";
        gateway = "192.168.1.1";
      };
    };
  };
}

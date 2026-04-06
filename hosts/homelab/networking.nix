{
  config,
  lib,
  ...
}:
{
  sops.templates."wireless-file" = {
    owner = "wpa_supplicant";
    content = ''
      psk_zyxel=${config.sops.placeholder."zyxel/pass"}
    '';
  };

  networking = {
    hostName = "homelab";

    networkmanager.enable = lib.mkForce false;

    wireless = {
      enable = true;
      secretsFile = config.sops.templates."wireless-file".path;
      networks."Zyxel_2031".pskRaw = "ext:psk_zyxel";
    };
    defaultGateway = "192.168.1.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    interfaces."wlo1" = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.10";
          prefixLength = 24;
        }
      ];
    };
  };
}

{
  config,
  ...
}:
{
  sops = {
    secrets = {
      "zyxel/pass" = { };
    };
    templates.zyxel-env.content = ''
      ZYXEL_PASS=${config.sops.placeholder."zyxel/pass"}
    '';
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.sops.templates.zyxel-env.path
    ];

    profiles."zyxel" = {
      connection = {
        id = "zyxel";
        type = "wifi";
      };
      wifi.ssid = "Zyxel_2031";
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$ZYXEL_PASS";
      };
    };
  };

}

{
  config,
  ...
}:
{
  sops = {
    secrets = {
      "eduroam/id" = { };
      "eduroam/pass" = { };
    };
    templates.eduroam-env.content = ''
      EDUROAM_ID=${config.sops.placeholder."eduroam/id"}
      EDUROAM_PASS=${config.sops.placeholder."eduroam/pass"}
    '';
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.sops.templates.eduroam-env.path
    ];

    profiles = {
      "eduroam" = {
        connection = {
          id = "eduroam";
          type = "wifi";
          autoconnect = true;
          autoconnect-priority = 100;
        };
        wifi.ssid = "eduroam";
        wifi-security.key-mgmt = "wpa-eap";

        "802-1x" = {
          eap = "peap;";
          identity = "$EDUROAM_ID";
          password = "$EDUROAM_PASS";
          phase2-auth = "mschapv2";
        };
      };
    };
  };
}

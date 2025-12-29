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
          uuid = "e0339bbe-1bf3-4a90-8969-967b3c105792";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          eap = "peap;";
          identity = "$EDUROAM_ID";
          password = "$EDUROAM_PASS";
          phase2-auth = "mschapv2";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
      };
    };
  };
}

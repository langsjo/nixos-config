{
  config,
  pkgs,
  ...
}:
let
  cert = pkgs.writeText "aalto-tls-ca-crt" ''
    -----BEGIN CERTIFICATE-----
    MIICVDCCAdugAwIBAgIQZ3SdjXfYO2rbIvT/WeK/zjAKBggqhkjOPQQDAzBsMQsw
    CQYDVQQGEwJHUjE3MDUGA1UECgwuSGVsbGVuaWMgQWNhZGVtaWMgYW5kIFJlc2Vh
    cmNoIEluc3RpdHV0aW9ucyBDQTEkMCIGA1UEAwwbSEFSSUNBIFRMUyBFQ0MgUm9v
    dCBDQSAyMDIxMB4XDTIxMDIxOTExMDExMFoXDTQ1MDIxMzExMDEwOVowbDELMAkG
    A1UEBhMCR1IxNzA1BgNVBAoMLkhlbGxlbmljIEFjYWRlbWljIGFuZCBSZXNlYXJj
    aCBJbnN0aXR1dGlvbnMgQ0ExJDAiBgNVBAMMG0hBUklDQSBUTFMgRUNDIFJvb3Qg
    Q0EgMjAyMTB2MBAGByqGSM49AgEGBSuBBAAiA2IABDgI/rGgltJ6rK9JOtDA4MM7
    KKrxcm1lAEeIhPyaJmuqS7psBAqIXhfyVYf8MLA04jRYVxqEU+kw2anylnTDUR9Y
    STHMmE5gEYd103KUkE+bECUqqHgtvpBBWJAVcqeht6NCMEAwDwYDVR0TAQH/BAUw
    AwEB/zAdBgNVHQ4EFgQUyRtTgRL+BNUW0aq8mm+3oJUZbsowDgYDVR0PAQH/BAQD
    AgGGMAoGCCqGSM49BAMDA2cAMGQCMBHervjcToiwqfAircJRQO9gcS3ujwLEXQNw
    SaSS6sUUiHCm0w2wqsosQJz76YJumgIwK0eaB8bRwoF8yguWGEEbo/QwCZ61IygN
    nxS2PFOiTAZpffpskcYqSUXm7LcT4Tps
    -----END CERTIFICATE-----
  '';

  mkAaltoProfile = ssid: prio: {
    connection = {
      id = ssid;
      type = "wifi";
      autoconnect = true;
      autoconnect-priority = prio;
    };
    wifi.ssid = ssid;
    wifi-security.key-mgmt = "wpa-eap";

    "802-1x" = {
      eap = "peap;";
      ca-cert = cert.outPath;
      domain-match = "radius.org.aalto.fi";
      identity = "$EDUROAM_ID";
      password = "$EDUROAM_PASS";
      phase2-auth = "mschapv2";
    };
  };
in
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
      # "eduroam" = mkAaltoProfile "eduroam" 100;
      "aalto" = mkAaltoProfile "aalto" 150;
    };
  };
}

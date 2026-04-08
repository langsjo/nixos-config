{
  config,
  ...
}:
{
  sops.secrets."tailscale-auth-key" = { };
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets."tailscale-auth-key".path;
    extraUpFlags = [
      "--login-server=https://headscale.gorilla.gay"
    ];
  };
}

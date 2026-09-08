{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [
      "--login-server=https://headscale.gorilla.gay"
    ];
  };
}

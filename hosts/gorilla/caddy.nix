{
  lib,
  ...
}:
{
  services.caddy = {
    enable = true;
    globalConfig = ''
      default_bind 100.64.0.2
      auto_https disable_certs
    '';
  };

  # allow restarting in case tailscale is not yet up to bind to ip
  systemd.services.caddy = {
    unitConfig = {
      StartLimitIntervalSec = lib.mkForce "0s";
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
      RestartMaxDelaySec = "5min";
      RestartSteps = 10;
    };
  };
}

{
  config,
  ...
}:
{
  services = {
    openssh = {
      enable = true;
      ports = [ ];
      openFirewall = false;
      listenAddresses = [
        {
          addr = "100.64.0.2";
          port = 22;
        }
      ];

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ config.custom.user.username ];
      };
    };
    fail2ban.enable = true;
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];

  systemd.services.sshd = {
    wants = [
      "network-online.target"
      "tailscaled.service"
    ];
    after = [
      "network-online.target"
      "tailscaled.service"
    ];
  };

  users.users.${config.custom.user.username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEttEBVPGpr80Hj0QJ7DiQVQw8SyO7rFW0AE0KYaZcfo langsjo"
    ];
  };
}

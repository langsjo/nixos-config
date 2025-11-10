{
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = true;
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
    fail2ban.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
  ];
}

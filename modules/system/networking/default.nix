{
  imports = [
    ./nm-profiles
  ];

  networking.networkmanager.enable = true;
  custom.user.extraGroups = [ "networkmanager" ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
    fail2ban.enable = true;
  };
}

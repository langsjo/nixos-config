{
  pkgs,
  ...
}:
{
  imports = [
    ./nm-profiles
  ];

  programs.nm-applet.enable = true;
  networking.networkmanager = {
    enable = true;
    plugins = [
      pkgs.networkmanager-openconnect
    ];
  };
  custom.user.extraGroups = [ "networkmanager" ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    fail2ban.enable = true;
  };
}

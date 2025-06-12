{
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
  ];
}

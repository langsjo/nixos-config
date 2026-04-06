{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.openssh;
in
{
  options.custom.openssh = {
    enable = lib.mkEnableOption "openssh server";
  };

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ config.custom.user.username ];
        };
      };
      fail2ban.enable = true;
    };

    users.users.${config.custom.user.username} = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII81x/a9yvz8juJTw0uyFwbgR5o6LausMOHWA1rwbzE7 langsjo@kehvatsu"
      ];
    };
  };
}

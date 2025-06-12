{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.user;
in
{
  options.custom.user = {
    username = lib.mkOption {
      description = "User's username";
      type = lib.types.str;
      default = "langsjo";
    };

    homeDirectory = lib.mkOption {
      description = "User's home directory";
      type = lib.types.str;
      default = "/home/${cfg.username}";
      defaultText = "/home/\${config.custom.user.username}";
    };
  };

  config = {
    users = {
      users.${cfg.username} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "docker"
        ];

        useDefaultShell = true;
      };

      defaultUserShell = pkgs.zsh;
    };

    programs.zsh.enable = true;
  };
}

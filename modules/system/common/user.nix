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

    extraGroups = lib.mkOption {
      description = "Extra groups to add the user to";
      type = with lib.types; listOf str;
      default = [ ];
    };

    homeDirectory = lib.mkOption {
      description = "User's home directory";
      type = lib.types.str;
      default = "/home/${cfg.username}";
      defaultText = "/home/{config.custom.user.username}";
    };
  };

  config = {
    custom.user.extraGroups = [
      "wheel"
      "video"
    ];

    users = {
      users.${cfg.username} = {
        isNormalUser = true;
        extraGroups = cfg.extraGroups;

        useDefaultShell = true;
      };

      defaultUserShell = pkgs.zsh;
    };

    programs.zsh.enable = true;
  };
}

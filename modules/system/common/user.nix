{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.user;
  inherit (lib) types mkOption;
in
{
  options.custom.user = {
    username = mkOption {
      description = "Username";
      type = types.str;
      default = "langsjo";
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
  };
}

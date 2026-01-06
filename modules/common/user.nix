{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.user;
  secrets = config.sops.secrets;
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

  # Ensure ZSH exists
  imports = [
    ../programs/zsh.nix
  ];

  config = {
    custom.user.extraGroups = [
      "wheel"
      "video"
    ];

    sops.secrets = {
      "users/hashed-user-pass" = {
        neededForUsers = true;
      };
      "users/hashed-root-pass" = {
        neededForUsers = true;
      };
    };

    users = {
      users."root" = {
        hashedPasswordFile = secrets."users/hashed-root-pass".path;
        ignoreShellProgramCheck = true;
      };

      users."${cfg.username}" = {
        isNormalUser = true;
        extraGroups = cfg.extraGroups;
        hashedPasswordFile = secrets."users/hashed-user-pass".path;

        useDefaultShell = true;
        ignoreShellProgramCheck = true;
      };
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;
    };
  };
}

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

    shell = lib.mkOption {
      description = "User's login shell";
      type = lib.types.package;
      default = config.custom.wrappers.zsh;
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
    ];

    sops.secrets = {
      "users/hashed-user-pass" = {
        neededForUsers = true;
      };
    };

    users = {
      users."root" = {
        hashedPassword = "!";
      };

      users."${cfg.username}" = {
        isNormalUser = true;
        extraGroups = cfg.extraGroups;
        hashedPasswordFile = secrets."users/hashed-user-pass".path;
        shell = cfg.shell;
        ignoreShellProgramCheck = true;
      };

      mutableUsers = false;
      defaultUserShell = pkgs.bash;
    };
    programs.bash.enable = true;
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.user;
  secrets = config.sops.secrets;

  pgpFileDefault = pkgs.fetchurl {
    url = "https://keys.openpgp.org/vks/v1/by-fingerprint/${cfg.pgpKey.fingerprint}";
    hash = "sha256-kB6xIF9TTe7P5TO1zkTcVILxc3ZlG0Q3FUsRy30kFrk=";
  };
in
{
  options.custom.user = {
    username = lib.mkOption {
      description = "User's username";
      type = lib.types.str;
      default = "langsjo";
    };

    pgpKey = {
      fingerprint = lib.mkOption {
        description = "User's PGP key fingerprint";
        type = lib.types.str;
        default = "BF1A4151F2E25E6F92C3527C932CF958F022A14B";
      };
      file = lib.mkOption {
        description = "File with user's PGP public key";
        type = lib.types.path;
        default = pgpFileDefault;
      };
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

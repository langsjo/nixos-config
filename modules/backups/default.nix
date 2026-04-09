{
  config,
  lib,
  ...
}:
let
  backupsType = lib.types.submodule {
    options = {
      user = lib.mkOption {
        description = "user to run backups as";
        type = lib.types.str;
      };
      repo = lib.mkOption {
        description = "the repository";
        type = lib.types.str;
      };
      paths = lib.mkOption {
        description = "paths to back up";
        type = with lib.types; listOf str;
      };
      tag = lib.mkOption {
        description = "Tag to tag the backup with";
        type = lib.types.str;
      };
      passwordFile = lib.mkOption {
        description = "file with password to the restic repo";
        type = lib.types.path;
      };
      pruneOpts = lib.mkOption {
        description = ''
          Flags to pass to `restic forget --prune` after backing up
        '';
        type = with lib.types; listOf str;
      };

      exclude = lib.mkOption {
        description = "paths to exclude";
        type = with lib.types; listOf str;
        default = [ ];
      };
      dates = lib.mkOption {
        description = ''
          The times that the backup will run. Format specified by `systemd.time(7)`
        '';
        type = with lib.types; listOf str;
        default = [ "03:00 Europe/Helsinki" ];
      };
      backupArgs = lib.mkOption {
        description = "Extra flags to pass to `restic backup`";
        type = with lib.types; listOf str;
        default = [ ];
      };
      checkOpts = lib.mkOption {
        description = "Extra flags to pass to `restic check` after a backup";
        type = with lib.types; listOf str;
        default = [ ];
      };
    };
    config = {
      backupArgs = [
        "--exclude-caches"
        "--one-file-system"
        "--pack-size 128"
      ];
    };
  };
in
{
  options.custom.backups = {
    jobs = lib.mkOption {
      description = "backups to run to gorilla";
      type = lib.types.attrsOf backupsType;
      default = { };
    };
    environmentFile = lib.mkOption {
      description = "Environment file for backup jobs, should contain REST authentication";
      type = lib.types.path;
    };
  };

  config = {
    services.restic.backups = builtins.mapAttrs (_: cfg: {
      inherit (cfg)
        user
        paths
        passwordFile
        exclude
        ;
      repository = "rest:https://restic.gorilla.gay/${cfg.repo}";
      initialize = true;
      extraBackupArgs = cfg.backupArgs ++ [ "--tag ${cfg.tag}" ];
      pruneOpts = cfg.pruneOpts ++ lib.optionals (cfg.pruneOpts != [ ]) [ "--tag ${cfg.tag}" ];
      checkOpts = cfg.checkOpts ++ [ "--with-cache" ];
      progressFps = 0.0167; # Once per min
      environmentFile = config.custom.backups.environmentFile;
      timerConfig = {
        OnCalendar = cfg.dates;
        Persistent = true;
        RandomizedDelaySec = "30min";
      };
    }) config.custom.backups.jobs;
  };
}

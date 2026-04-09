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
        description = "the repository path";
        type = lib.types.str;
      };
      paths = lib.mkOption {
        description = "paths to back up";
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
      };
      pruneOpts = lib.mkOption {
        description = ''
          Flags to pass to `restic forget --prune` after backing up
        '';
        type = with lib.types; listOf str;
      };
      extraBackupArgs = lib.mkOption {
        description = "Flags to pass to `restic backup`";
        type = with lib.types; listOf str;
        default = [ ];
      };
      passwordFile = lib.mkOption {
        description = "file with password to the restic repo";
        type = lib.types.path;
      };
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
        paths
        pruneOpts
        passwordFile
        extraBackupArgs
        exclude
        user
        ;
      initialize = true;
      environmentFile = config.custom.backups.environmentFile;
      timerConfig = {
        OnCalendar = cfg.dates;
        Persistent = true;
        RandomizedDelaySec = "30min";
      };
      repository = cfg.repo;
      runCheck = true;
      checkOpts = [ "--read-data-subset 10%" ];
      progressFps = 0.0167; # Once per min
    }) config.custom.backups.jobs;
  };
}

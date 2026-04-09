{
  config,
  ...
}:
{
  sops = {
    secrets = {
      "restic-server-passwd" = {
        sopsFile = ../../modules/secrets/kehvatsu/default.yaml;
      };
      "restic-encryption-passwd" = {
        sopsFile = ../../modules/secrets/kehvatsu/default.yaml;
        owner = config.custom.user.username;
      };
    };
    templates."restic-env-file" = {
      owner = config.custom.user.username;
      content = ''
        RESTIC_REST_USERNAME=kehvatsu
        RESTIC_REST_PASSWORD=${config.sops.placeholder."restic-server-passwd"}
      '';
    };
  };

  custom.backups = {
    environmentFile = config.sops.templates."restic-env-file".path;
    jobs."home" = {
      user = config.custom.user.username;
      repo = "rest:https://restic.gorilla.gay/kehvatsu";
      dates = [
        "03:00 Europe/Helsinki"
      ];
      paths = [
        config.custom.user.homeDirectory
      ];
      exclude = [
        "${config.custom.user.homeDirectory}/.cache"
      ];
      extraBackupArgs = [
        "--exclude-caches"
        "--tag home"
        "--pack-size 128"
      ];
      pruneOpts = [
        "--tag home"
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
      passwordFile = config.sops.secrets."restic-encryption-passwd".path;
    };
  };
}

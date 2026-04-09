{
  config,
  ...
}:
{
  sops.secrets."exthdd_luks_keyfile" = {
    sopsFile = ../../modules/secrets/gorilla/exthdd_luks_keyfile;
    format = "binary";
  };
  environment.etc.crypttab = {
    text = ''
      exthdd_lvm /dev/disk/by-label/EXTHDD_LUKS ${
        config.sops.secrets."exthdd_luks_keyfile".path
      } luks,nofail,noauto
    '';
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/mapper/exthdd-backups";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10m"
      "x-systemd.device-timeout=30s"
      "x-systemd.mount-timeout=10s"
      "x-systemd.requires=systemd-cryptsetup@exthdd_lvm.service"
      "x-systemd.after=systemd-cryptsetup@exthdd_lvm.service"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/backup 0700 restic restic -"
  ];
}

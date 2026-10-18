{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.arr;
in
{
  imports = [
    ./jellyfin.nix
    ./qbittorrent.nix
    ./wireguard.nix
  ];
  options.custom.arr = {
    enable = lib.mkEnableOption "hosting arr stack";
  };

  config = lib.mkIf cfg.enable {
    users.groups.media = { };
    custom.user.extraGroups = [ "media" ];
    systemd.tmpfiles.rules = [
      "d /srv/media 2775 root media -"
    ];
  };
}

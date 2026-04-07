{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.virt;
in
{
  options.custom.virt.enable = lib.mkEnableOption "virtualisation features" // {
    default = true;
  };
  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker.enable = true;
      podman = {
        enable = true;
      };
    };

    custom.user.extraGroups = [ "docker" ];

    environment.systemPackages = [
      pkgs.distrobox
    ];
  };
}

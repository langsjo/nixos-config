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
  options.custom.virt = {
    podman.enable = lib.mkEnableOption "rootless podman";
    libvirt.enable = lib.mkEnableOption "libvirt VMs";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.podman.enable {
      virtualisation = {
        containers = {
          enable = true;
          registries.settings.search = [ "docker.io" ];
        };

        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
      # disable rootful socket
      systemd.sockets.podman.enable = false;
      environment.systemPackages = [ pkgs.podman-compose ];
      users.users.${config.custom.user.username} = {
        autoSubUidGidRange = true;
      };
    })

    (lib.mkIf cfg.libvirt.enable {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
    })
  ];
}

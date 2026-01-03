{
  pkgs,
  ...
}:
{
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
}

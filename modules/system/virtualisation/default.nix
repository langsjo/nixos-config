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

  environment.systemPackages = [
    pkgs.distrobox
  ];
}

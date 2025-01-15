{ pkgs, ... }: {

  imports = [
  ];

  users.users.langsjo.packages = with pkgs; [
    zoom-us
  ];

  environment.systemPackages = [
  ];

  programs = {
    slock.enable = true;
    light.enable = true;
  };

  virtualisation.docker.enable = true;
}

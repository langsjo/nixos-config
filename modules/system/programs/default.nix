{ pkgs, ... }: {

  imports = [
  ];

  environment.systemPackages = with pkgs; [
    unzip
    zip
  ];

  programs = {
    slock.enable = true;
    light.enable = true;
  };

  virtualisation.docker.enable = true;
}

{ pkgs, ... }: {

  imports = [
  ];

  environment.systemPackages = with pkgs; [
    unzip
    zip
    comma
  ];

  programs = {
    slock.enable = true;
    light.enable = true;
  };

  virtualisation.docker.enable = true;
}

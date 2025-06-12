{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./gui
  ];

  environment.systemPackages = with pkgs; [
    git
    gh
    unzip
    zip
    comma
    btop
    nix-output-monitor # Maybe package the rebuild script?
    devenv
    tree
    vim
    libqalculate
  ];

  programs = {
    light.enable = config.custom.isLaptop;
  };

  virtualisation.docker.enable = true;
}

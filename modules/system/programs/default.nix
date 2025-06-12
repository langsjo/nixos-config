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
    light.enable = true;
  };

  virtualisation.docker.enable = true;
}

{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
let
  gpuType = config.custom.hardware.gpuType;
  btop' =
    if gpuType == "nvidia" then
      pkgs.btop-cuda
    else if gpuType == "amd" then
      pkgs.btop-rocm
    else
      pkgs.btop;
in
{
  imports = [
    ./gui
    ./git.nix
  ];

  environment.systemPackages = with pkgs; [
    gh
    unzip
    zip
    pkgs-unstable.comma
    devenv
    tree
    vim
    libqalculate
    dust

    btop'
    (pkgs.callPackage "${inputs.self}/utils/rebuild-script.nix" { })
  ];

  programs = {
    light.enable = config.custom.isLaptop;
    bat.enable = true;
  };

  virtualisation.docker.enable = true;
}

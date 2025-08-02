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
  ];

  environment.systemPackages = with pkgs; [
    git
    gh
    unzip
    zip
    pkgs-unstable.comma
    devenv
    tree
    vim
    libqalculate

    btop'
    (pkgs.callPackage "${inputs.self}/utils/rebuild-script.nix" { })
  ];

  programs = {
    light.enable = config.custom.isLaptop;
  };

  virtualisation.docker.enable = true;
}

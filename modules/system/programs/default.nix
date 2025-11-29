
{
  config,
  pkgs,
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
    ./tmux.nix
    ./zsh.nix

    inputs.nix-index-database.nixosModules.nix-index
  ];

  environment.systemPackages = with pkgs; [
    gh
    unzip
    zip
    tree
    vim
    libqalculate
    dust
    file

    btop'
    (pkgs.callPackage "${inputs.self}/utils/rebuild-script.nix" { })
  ];

  programs = {
    light.enable = config.custom.isLaptop;
    bat.enable = true;

    nix-index-database.comma.enable = true;
  };
}

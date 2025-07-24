{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
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
    pkgs-unstable.comma
    btop
    devenv
    tree
    vim
    libqalculate

    (pkgs.callPackage "${inputs.self}/utils/rebuild-script.nix" { })
  ];

  programs = {
    light.enable = config.custom.isLaptop;
  };

  virtualisation.docker.enable = true;
}

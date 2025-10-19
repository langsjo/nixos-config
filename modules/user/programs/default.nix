{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./gui
    ./neovim
    ./networkmanager-dmenu.nix

    inputs.nix-index-database.homeModules.nix-index
  ];
}

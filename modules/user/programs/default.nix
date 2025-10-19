{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./gui
    ./neovim

    inputs.nix-index-database.homeModules.nix-index
  ];
}

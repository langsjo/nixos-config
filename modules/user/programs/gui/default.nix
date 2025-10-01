{
  osConfig,
  lib,
  ...
}:
{
  imports = [
    ./alacritty.nix
  ];

  config = lib.mkIf osConfig.custom.gui.programs.enable {
    programs.firefox.enable = true;
  };
}

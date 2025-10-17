{
  osConfig,
  lib,
  ...
}:
{
  imports = [
  ];

  config = lib.mkIf osConfig.custom.gui.programs.enable {
    programs.firefox.enable = true;
  };
}

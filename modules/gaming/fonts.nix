{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gaming;
in
{
  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      corefonts
      vista-fonts
    ];
  };
}

{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gui.waybar;
in
{
  options.custom.gui.waybar.enable = lib.mkEnableOption "waybar";
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
    };
  };
}

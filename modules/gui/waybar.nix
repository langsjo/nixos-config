{
  inputs,
  pkgs,
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
    custom.wrappers.waybar = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.waybar-wrapped;
    programs.waybar = {
      enable = true;
      package = config.custom.wrappers.waybar;
    };
  };
}

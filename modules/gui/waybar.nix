{
  myPkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gui.waybar;
in
{
  options.custom.gui.waybar = {
    enable = lib.mkEnableOption "waybar";
    target = lib.mkOption {
      description = "systemd user unit to follow";
      default = null;
      example = "niri.service";
      type = with lib.types; nullOr str;
    };
  };
  config = lib.mkIf cfg.enable {
    custom.wrappers.waybar = myPkgs.waybar-wrapped;
    programs.waybar = {
      enable = true;
      package = config.custom.wrappers.waybar;
      systemd.target = cfg.target;
    };
  };
}

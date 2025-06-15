{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui;
in
{
  options.custom.gui.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable programs that require a GUI";
    default = true;
  };

  imports = [
    ./ly.nix
    ./dwm.nix
    ./dwm-status.nix
    ./xserver.nix
  ];

  config = lib.mkIf cfg.enable {
  };
}

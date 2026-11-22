{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gui;
in
{
  options.custom.gui.enable = lib.mkEnableOption "a GUI environment";

  imports = [
    ./ly.nix
    ./dwm
    ./xserver.nix
    ./plasma6.nix
    ./niri.nix
    ./waybar.nix
    ./swayidle.nix
    ./theme.nix
  ];

  config = lib.mkIf cfg.enable {
    services.speechd.enable = false;
    custom.user.extraGroups = [ "video" ];
  };
}

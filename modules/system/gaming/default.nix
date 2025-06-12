{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gaming;
in
{
  options.custom.gaming.enable = lib.mkEnableOption "Enable gaming related programs and services";

  imports = [
    ./steam.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;
  };
}

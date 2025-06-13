{
  config,
  lib,
  pkgs,
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
    services.ratbagd.enable = true;

    environment.systemPackages = with pkgs; [
      piper
    ];
  };
}

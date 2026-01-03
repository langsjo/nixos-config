{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.custom.gaming.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        mangohud
        gamescope
        gamemode
      ];
    };
  };
}

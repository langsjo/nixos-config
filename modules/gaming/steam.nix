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
      extraPackages = with pkgs; [
        gamescope
        gamemode
      ];
    };
  };
}

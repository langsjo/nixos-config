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
    ./fonts.nix
    ./light.nix
  ];

  config = lib.mkIf cfg.enable {
    services.ratbagd.enable = true;

    programs.gamemode.enable = true;
    users.users.${config.custom.user.username}.extraGroups = [ "gamemode" ];

    programs.gamescope = {
      enable = true;
    };

    # For Roblox :)
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal ];
      extraPortals = [ pkgs.xdg-desktop-portal ];
    };

    environment.systemPackages = with pkgs; [
      piper
      (lutris.override {
        extraPkgs =
          p: with p; [
            gamemode
            proton-ge-bin
            wineWowPackages.full
          ];
      })
    ];
  };
}

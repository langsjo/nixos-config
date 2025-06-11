{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.dwm;
in
{
  options.custom.wm.dwm.enable = lib.mkEnableOption "Enable the dwm window manager";

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (prevAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "langsjo";
          repo = "dwm";
          rev = "0ab174a6e2b7753121042076aec96dfe5fea93ed";
          hash = "sha256-wpGkTMyldEqWSGInKweU9kdrVVf14pzNSjuKAVCaYUk=";
        };
      });
    };

    # dwm requires xserver, so enable custom xserver module by default
    custom.services.xserver.enable = lib.mkDefault true;
  };
}

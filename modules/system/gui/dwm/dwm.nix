{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.windowManager.dwm;

  src = pkgs.fetchFromGitHub {
    owner = "langsjo";
    repo = "dwm";
    rev = "19b72543759586618433a3c352f35712c9943002";
    hash = "sha256-NvRSuHCken1+Lt4qRT/mun87P/WDbK/OgeFA6+peBrU=";
  };

  package = pkgs.dwm.overrideAttrs (prevAttrs: {
    inherit src;
    patches = prevAttrs.patches ++ [
      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/removeborder/dwm-removeborder-20220626-d3f93c7.diff"; # remove border from window if only 1 window on screen
        hash = "sha256-0QUN+wfKyXxabXyKXIcpPcdnLkH4d0Oqx8pncjc+It4=";
      })
    ];
  });
in
{
  options.custom.gui.windowManager.dwm.enable = lib.mkEnableOption "Enable the dwm window manager";

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.dwm = {
      enable = true;
      inherit package;
    };
    custom.gui.xserver.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      rofi
      rofi-screenshot
      config.wrappers.alacritty.result
      config.wrappers.networkmanager_dmenu.result

      dunst # For notifications
    ];

    programs = {
      light.enable = config.custom.isLaptop;
      thunar.enable = true;
      firefox.enable = true;
      slock.enable = true;
    };

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "dwm cannot be enabled with gui disabled";
      }
      {
        assertion = !config.custom.gui.xserver.enable -> !cfg.enable;
        message = "dwm cannot be enabled with xserver disabled";
      }
    ];
  };
}

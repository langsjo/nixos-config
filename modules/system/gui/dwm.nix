{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.windowManager.dwm;

  # Extra things to enable so that dwm binds and such work
  extraNixosConfig = {
    environment.systemPackages = with pkgs; [
      rofi
      rofi-screenshot
      config.wrappers.alacritty.result
      networkmanager_dmenu

      dunst # For notifications
    ];

    custom.gui.xserver.enable = lib.mkDefault true;
    programs = {
      light.enable = config.custom.isLaptop;
      thunar.enable = true;
      firefox.enable = true;
      slock.enable = true;
    };
  };

  src = pkgs.fetchFromGitHub {
    owner = "langsjo";
    repo = "dwm";
    rev = "a9a2a3a241bfbc4d4bc613bce1a2f54de01aee99";
    hash = "sha256-FmE27lI41OP0TQwH3ywI3StwsInp3l5YTeTf3nqLO50=";
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

  config = lib.mkIf cfg.enable (
    {
      services.xserver.windowManager.dwm = {
        enable = true;
        inherit package;
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
    }
    // extraNixosConfig
  );
}

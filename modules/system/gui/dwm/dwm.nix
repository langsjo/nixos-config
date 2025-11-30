{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.windowManager.dwm;

  dwm' = pkgs.dwm.override {
    conf = ./config/config.h;
    patches = [
      ./config/0001-increase-bar-height.patch
      (pkgs.fetchpatch2 { # remove border from window if only 1 window on screen
        url = "https://dwm.suckless.org/patches/removeborder/dwm-removeborder-20220626-d3f93c7.diff";
        hash = "sha256-u19eRqUHTQf4c3ronjOBZkdzFHJqicIt89RKYBPkhsU=";
      })
    ];
  };
in
{
  options.custom.gui.windowManager.dwm.enable = lib.mkEnableOption "Enable the dwm window manager";

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.dwm = {
      enable = true;
      package = dwm';
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

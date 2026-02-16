{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.windowManager.dwm;

  networkmanager_dmenu-wrapped = inputs.wrapper-lib.lib.mkWrapper pkgs ./networkmanager_dmenu-wrapped.nix;
  dwm' = pkgs.dwm.override {
    conf = ./config/config.h;
    patches = [
      ./config/0001-increase-bar-height.patch
      (pkgs.fetchpatch2 {
        # remove border from window if only 1 window on screen
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
      networkmanager_dmenu-wrapped

      dunst # For notifications
    ];

    programs.slock.enable = true;

    systemd.services.slock-sleep = {
      description = "Lock screen with slock on sleep";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      serviceConfig = {
        Type = "simple";
        Environment = "DISPLAY=:0";
        ExecCondition = "${lib.getExe' pkgs.procps "pgrep"} -x dwm"; # Only run if dwm is running
        ExecStart = "/run/wrappers/bin/slock";
      };
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

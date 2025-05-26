{
  config,
  pkgs,
  lib,
  ...
}:
let
  sxwm = pkgs.callPackage ./sxwm.nix { };
  cfg = config.services.xserver.windowManager.sxwm;
in
{
  options.services.xserver.windowManager.sxwm = {
    enable = lib.mkEnableOption "sxwm window manager";
    package = lib.mkOption {
      type = lib.types.package;
      default = sxwm;
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = [
      {
        name = "sxwm";
        start = ''
          ${lib.getExe' cfg.package "sxwm"} &
          waitPID=$!
        '';
      }
    ];

    environment.systemPackages = [
      cfg.package
    ];
  };
}

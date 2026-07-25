{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.gui.swayidle;
in
{
  options.custom.gui.swayidle = {
    enable = lib.mkEnableOption "swayidle";
    targets = lib.mkOption {
      description = "systemd targets to bind to";
      type = with lib.types; listOf str;
      default = [ "graphical-session.target" ];
    };
  };
  config = lib.mkIf cfg.enable {
    custom.wrappers.swayidle = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.swayidle-wrapped;
    systemd.user.services.swayidle = {
      wantedBy = cfg.targets;
      partOf = cfg.targets;
      after = cfg.targets;
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = lib.getExe config.custom.wrappers.swayidle;
      };
    };
  };
}

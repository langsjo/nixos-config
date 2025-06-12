{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware.audio;
in
{
  options.custom.hardware.audio.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable audio";
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}

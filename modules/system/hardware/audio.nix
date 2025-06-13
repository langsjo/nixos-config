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
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}

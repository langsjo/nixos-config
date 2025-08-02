{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.hardware;
in
{
  options.custom.hardware = {
    gpuType = lib.mkOption {
      type =
        with lib.types;
        nullOr (enum [
          "nvidia"
          "amd"
          "intel"
        ]);
      default = null;
      description = "What type of GPU the host has";
      example = "nvidia";
    };
  };

  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./power.nix
    ./zram.nix
    ./graphics.nix
  ];
}

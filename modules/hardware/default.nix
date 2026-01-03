{
  config,
  lib,
  ...
}:
let
  nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;
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
      default = if nvidiaEnabled then "nvidia" else null;
      defaultText = lib.literalExpression ''"nvidia" if nvidia drivers enabled, null otherwise'';
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

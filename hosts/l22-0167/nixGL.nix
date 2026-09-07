{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.custom.nixGL = lib.mkOption {
    description = "nixGL package to use";
    type = lib.types.package;
  };
  config = {
    custom.nixGL = inputs.nixGL.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel;
    home.packages = [ config.custom.nixGL ];
  };
}

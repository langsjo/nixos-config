# Options that don't fit elsewhere
{
  lib,
  ...
}:
{
  options.custom = {
    isLaptop = lib.mkEnableOption "Is the host a laptop";
    screen = {
      dpi = lib.mkOption {
        type = lib.types.int;
        description = "The dpi of the screen";
        default = 96;
      };
    };
  };
}

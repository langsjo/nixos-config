# Options that don't fit elsewhere
{
  lib,
  ...
}:
{
  options.custom = {
    isLaptop = lib.mkEnableOption "Is the host a laptop";
  };
}

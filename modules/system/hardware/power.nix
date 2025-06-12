{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.isLaptop {
    services = {
      upower.enable = true;
      tlp.enable = true;
    };
  };
}

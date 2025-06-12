{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.gaming.enable {
    programs.steam.enable = true;
  };
}

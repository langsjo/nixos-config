{
  config,
  osConfig,
  lib,
  ...
}:
let
  cfg = config.custom;
in
{
  options.custom.stateVersion = lib.mkOption {
    description = "`stateVersion` variable option to set `home.stateVersion` to";
    example = "25.05";
    type = lib.types.str;

    default = osConfig.system.stateVersion; # Set to NixOS stateVersion by default
    defaultText = lib.literalExpression "osConfig.system.stateVersion";
  };

  config = {
    programs.home-manager.enable = true;

    home = {
      inherit (osConfig.custom.user) username homeDirectory;
      stateVersion = cfg.stateVersion;
    };
  };
}

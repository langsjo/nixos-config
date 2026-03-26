{
  lib,
  pkgs,
  ...
}:
let
  formatters = {
    nix = pkgs.nixfmt;
  };

  conformConfig = {
    formatters_by_ft = builtins.mapAttrs (_: package: [ (lib.getName package) ]) formatters;
    formatters = lib.mapAttrs' (_: package: {
      name = lib.getName package;
      value.command = lib.getExe package;
    }) formatters;
  };
in
{
  plugins.conform-nvim = {
    enable = true;
    settings = conformConfig // {
      format_on_save = {
        timeout_ms = 500;
      };
    };
  };
}

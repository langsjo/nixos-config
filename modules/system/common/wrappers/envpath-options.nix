{
  config,
  pkgs,
  name,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;
in
{
  options = {
    source = mkOption {
      description = "Path of the source file or directory";
      type = with types; nullOr path;
    };

    text = mkOption {
      description = ''
        Text that will be put in the resulting file. This is an
        alternative to using `source`, where `source` takes precedent.
      '';
      type = with types; nullOr lines;
    };

    executable = mkOption {
      description = ''
        Whether the file should be given execute permissions.
        If null, uses the permission of the source file.
      '';
      type = with types; nullOr bool;
    };
  };

  config = {
    source = mkIf (config.text != null) (
      mkDefault (
        pkgs.writeTextFile {
          inherit (config) text;
          executable = config.executable == true;
          name = builtins.baseNameOf name;
        }
      )
    );
  };
}

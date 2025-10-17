{
  pkgs,
}:
{
  config,
  name,
  lib,
  ...
}:
let
  inherit (lib)
    literalExample
    mkDefault
    mkIf
    mkMerge
    mkOption
    types
    ;

  inherit (pkgs) formats;

  filename =
    let
      basename = builtins.baseNameOf name;
    in
    if basename != "" then basename else "root-file";
in
{
  options = {
    source = mkOption {
      description = "Path of the source file or directory";
      type = types.path;
    };

    generate = {
      value = mkOption {
        description = "The attribute set to generate a file out of";
        type = with types; nullOr attrs;
        default = null;
      };

      format = mkOption {
        description = ''
          The format to use for turning `value` into a file.

          Formats can be found in `pkgs.formats`, and they must be called 
          before using them like so: `pkgs.formats.<format> { }`
        '';
        type = with types; nullOr attrs;
        default = null;
        example = literalExample "pkgs.formats.toml { }";
      };

      generator = mkOption {
        description = ''
          A function that when called with the `value` attribute set returns
          a derivation of a text file that will be used for this path.

          This is an alternative, more fine grained alternative to using `format`,
          and `format` actually gets converted to this option if used.
        '';
        type = with types; nullOr (functionTo package);
        default = null;
        example = literalExample ''
          value: pkgs.writeText "my-json-config" (builtins.toJSON value)
        '';
      };

      realValue = mkOption {
        description = "Hidden value that is the real one used for generation";
        type = types.attrs;
        visible = false;
        internal = true;
      };
    };

    json = mkOption {
      description = "An attribute set to turn into a JSON file to be used as a source";
      type = types.nullOr (formats.json { }).type;
      default = null;
    };

    toml = mkOption {
      description = "An attribute set to turn into a TOML file to be used as a source";
      type = types.nullOr (formats.toml { }).type;
      default = null;
    };

    yaml = mkOption {
      description = "An attribute set to turn into a YAML file to be used as a source";
      type = types.nullOr (formats.yaml { }).type;
      default = null;
    };

    text = mkOption {
      description = ''
        Text that will be put in the resulting file. This is an
        alternative to using `source`, where `source` takes precedent.
      '';
      type = with types; nullOr lines;
      default = null;
    };

    executable = mkOption {
      description = ''
        Whether the file should be given execute permissions.
        If null, uses the permission of the source file.
      '';
      type = with types; nullOr bool;
      default = null;
    };
  };

  config = {
    generate = {
      format =
        let
          mkFormat = type: mkIf (config.${type} != null) (lib.mkDefault (formats.${type} { }));
        in
        lib.pipe
          [ "json" "toml" "yaml" ]
          [
            (map mkFormat)
            mkMerge
          ];

      generator = lib.mkDefault (config.generate.format.generate filename);

      realValue =
        let
          mkValue = type: mkIf (config.${type} != null) (lib.mkDefault (config.${type}));
        in
        mkMerge (
          (map mkValue [
            "json"
            "toml"
            "yaml"
          ])
          ++ [
            (mkIf (config.generate.value != null) (lib.mkDefault config.generate.value))
          ]
        );
    };

    source =
      let
        generated = config.generate.generator config.generate.realValue;
        text = pkgs.writeTextFile {
          inherit (config) text;
          executable = config.executable == true;
          name = filename;
        };
      in
      mkMerge [
        (mkIf (config.generate.realValue != null) (mkDefault generated))
        (mkIf (config.text != null) (mkDefault text))
      ];
  };
}

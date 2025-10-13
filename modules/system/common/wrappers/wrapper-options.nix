{
  lib,
  ...
}:
let
  inherit (lib)
    literalExample
    mkOption
    types
    ;

  fileBuilderType = types.attrsOf (types.submodule (import ./envpath-options.nix));
in
{
  options = {
    install = mkOption {
      description = "Whether to add the resulting wrapper to environment.systemPackages";
      type = types.bool;
      default = true;
      example = false;
    };

    basePackage = mkOption {
      description = "The base package to wrap";
      type = with types; nullOr package;
      default = null;
      example = literalExample "pkgs.hello";
    };

    result = mkOption {
      description = "The resulting wrapped package (read only)";
      type = types.package;
      readOnly = true;
    };

    useBinaryWrapper = mkOption {
      description = ''
        Whether to use `makeBinaryWrapper` instead of `makeWrapper` to create the wrapper.

        `makeWrapper` is required if the wrapper needs some shell features (such as looking up environment 
        variables at runtime) or its unique arguments. More Info about their differences 
        [here](https://nixos.org/manual/nixpkgs/unstable/#:~:text=Using%20the%20makeBinaryWrapper%20implementation)
      '';
      type = types.bool;
      default = true;
      example = false;
    };

    extraMakeWrapperArgs = mkOption {
      description = ''
        A list of extra arguments to pass to `make[Binary]Wrapper`.
      '';
      type = with types; listOf str;
      default = [ ];
      example = literalExample ''
        [
          "--chdir /nix/store"
          "--set-default XDG_CACHE_HOME /tmp"
        ]
      '';
    };

    flags = {
      normal = mkOption {
        description = ''
          A list of flags and/or args that the wrapper will always pass to the wrapped executable
        '';
        type = with types; listOf str;
        default = [ ];
        example = literalExample ''
          [
            "-c"
            "--binary ''${lib.getExe pkgs.hello}"
          ]
        '';
      };

      path = mkOption {
        description = ''
          Attribute set with keys as the flags and values as the definition
          of a store path that will be passed with the flag, ie. 
          `--config-dir <defined store path>`

          The value should be an attribute set where each key is the name of a
          file in the resulting directory, and "/" is the special name to define
          the store path to be a single link to something with `source`, or 
          a single file with `text`.

          The file can be declared to be in a subdirectory by setting the key name
          to resemble a path, ie. "lsp_configs/lsp.conf" will place a file in
          $out/lsp_configs/lsp.conf
        '';
        type = fileBuilderType;
        default = { };
        example = literalExample ''
          {
            "--config-dir" = {
              "conf_file.conf".text = ''' # Define the text which will be placed in the file
                value1 = 1
                value2 = 2
              ''';
              "lsp_configs/lsp.conf".source = ./my_lsp_config; # Setting the source of a single file in a subdirectory
              plugins_dir.source = ./my_plugins; # Setting the source of an entire directory
            };

            "--config-file"."/".text = "this is just a single file";
          }
        '';
      };
    };

    env =
      let
        mkEnvVarOption =
          description:
          mkOption {
            description = ''
              ${description}

              The value of each variable can be either a string, integer, path,
              or a list of the aforementioned. A list will be concatenated with
              colon characters as separators.

              If you wish to pass a path without copying that path to the store,
              represent it as a string or convert it to a string with `toString` 
              first.
            '';
            default = { };
            type =
              with types;
              attrsOf (oneOf [
                (listOf (oneOf [
                  int
                  str
                  path
                ]))
                int
                str
                path
              ]);
            # Turn values passed to strings, concatenate lists with ":" as separators,
            # and copy paths to the store
            apply =
              let
                # Copy paths to store by string interpolation
                toStr = v: if lib.isPath v then "${v}" else toString v;
              in
              lib.mapAttrs (_: v: if lib.isList v then (lib.concatMapStringsSep ":" toStr v) else toStr v);
          };
      in
      {
        vars = mkEnvVarOption "Environment variables to set for the wrapper";

        # TODO: allow separating by other than ':'
        prefixes = mkEnvVarOption ''
          Environment variables to prefix with a ':' as the separator.

          ie. setting this to
          {
            PATH = "''${pkgs.hello}/bin";
          }

          would set `PATH = /nix/store/AAAAAAAAA-hello-1.0.0/bin:$PATH`.
        '';
        suffixes = mkEnvVarOption ''
          Environment variables to suffix with a ':' as the separator.

          ie. setting this to
          {
            PATH = "''${pkgs.hello}/bin";
          }

          would set `PATH = $PATH:/nix/store/AAAAAAAAA-hello-1.0.0/bin`.

          This can be used to set ie. fallback paths for when a binary
          from $PATH should be used if found, but otherwise use the one 
          from the path specified here.
        '';

        paths = mkOption {
          description = ''
            Attribute set with keys as environment variable names and values as the
            definitions of store paths the variable will point to in the wrapper.

            The value should be an attribute set where each key is the name of a
            file in the resulting directory, and "/" is the special name to define
            the variable to point to just a file instead of a directory.

            The file can be declared to be in a subdirectory by setting the key name
            to resemble a path, ie. "lsp_configs/lsp.conf" will place a file in
            $out/lsp_configs/lsp.conf
          '';
          type = fileBuilderType;
          default = { };
          example = literalExample ''
            {
              CONFIG_DIR = {
                "conf_file.conf".text = ''' # Define the text which will be placed in the file
                  value1 = 1
                  value2 = 2
                ''';
                "lsp_configs/lsp.conf".source = ./my_lsp_config; # Setting the source of a single file in a subdirectory
                plugins_dir.source = ./my_plugins; # Setting the source of an entire directory
              };

              CONFIG_FILE."/".text = "this is just a single file";
            }
          '';
        };
      };
  };
}

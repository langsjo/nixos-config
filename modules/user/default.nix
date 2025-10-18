{
  config,
  inputs,
  pkgs-unstable,
  lib,
  ...
}:
let
  cfg = config.custom.home-manager;
in
{
  options.custom.home-manager = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    description = ''
      Attribute set to be passed to Home manager modules as custom config.
      Read custom options defined by Home manager modules to see possible options.

      The `enable` attribute defines whether Home manager is enabled at all.
    '';
    default = {
      enable = true;
    }; # Though the stateVersion default is not set here, it is set on the Home manager side

    defaultText = {
      enable = true;
      stateVersion = "{config.system.stateVersion}";
    };
  };

  imports = [
    inputs.home-manager.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;

      extraSpecialArgs = {
        inherit inputs pkgs-unstable;
      };
      users.${config.custom.user.username} = {
        imports = [
          ./programs
          ./services
          ./hm-options.nix
        ];

        # Pass the home-manager custom config, other than 'enable'
        # to home manager modules
        custom = builtins.removeAttrs cfg [ "enable" ];
      };
    };
  };
}

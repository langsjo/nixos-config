{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.isLaptop {
    services = {
      upower.enable = true;
      tlp = {
        package = pkgs.tlp.overrideAttrs (
          finalAttrs: old: {
            version = "1.10.2";
            src = pkgs.fetchFromGitHub {
              owner = "linrunner";
              repo = "TLP";
              rev = finalAttrs.version;
              hash = "sha256-/xTg53eJ+AKrlG++nQGLsosaWzg1JrwGIGB2+h0MZDI=";
            };
            patches =
              (builtins.filter (x: !lib.hasSuffix "0001-makefile-correctly-sed-paths.patch" x) old.patches)
              ++ [
                ./0001-makefile-correctly-sed-paths.patch
              ];
          }
        );
        settings = {
          TLP_PROFILE_AC = "PRF";
          TLP_PROFILE_BAT = "SAV";
          TLP_AUTO_SWITCH = 1;
        };
        enable = true;
        pd = {
          enable = true;
          package = pkgs.tlp-pd.overrideAttrs {
            inherit (config.services.tlp.package)
              version
              src
              patches
              postPatch
              ;
          };
        };
      };
    };
  };
}

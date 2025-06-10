{ pkgs, ... }:
{
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "langsjo";
        repo = "dwm";
        rev = "0ab174a6e2b7753121042076aec96dfe5fea93ed";
        hash = "sha256-wpGkTMyldEqWSGInKweU9kdrVVf14pzNSjuKAVCaYUk=";
      };
    };
  };
}

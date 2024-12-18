{ pkgs, lib, config, ... }: {

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = pkgs.fetchFromGitHub {
	owner = "bizrr";
	repo  = "dwm";
	rev   = "9d82be4f60f18d934502fab31c601ee9ac582c4a";
	hash  = "sha256-M5IShX7EbXRuJWAJRas9VW9/8lh9mo4w7SXrQIgCFHA=";
      };
    };
  };
}

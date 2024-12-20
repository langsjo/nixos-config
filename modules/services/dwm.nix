{ pkgs, lib, config, inputs, ... }: {
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = inputs.dwm;
    };
  };
}

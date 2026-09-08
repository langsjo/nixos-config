{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  customPkgs = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  firefox-script = pkgs.writeShellScriptBin "firefox-opener-proxy" ''
    exec firefox "$@"
  '';

  # Swaylock via Nix doesn't use right PAM modules
  swaylock-script = pkgs.writeShellScriptBin "swaylock-opener-proxy" ''
    export PATH="$PATH:/usr/bin"
    exec swaylock "$@"
  '';

  xwayland-satellite-script = pkgs.writeShellScriptBin "xwayland-satellite-proxy" ''
    exec /usr/local/bin/xwayland-satellite "$@"
  '';

  niriConfig = (customPkgs.niri-wrapped.override {
    firefox = firefox-script;
    swaylock = swaylock-script;
    kitty-wrapped = lib.findFirst (x: x.pname or x.name == "kitty-nixGL") null config.home.packages;
    xwayland-satellite = xwayland-satellite-script;

    xcursor-size = 16;
  }).envPaths.NIRI_CONFIG;
in
{
  home.file.".config/niri/config.kdl".source = niriConfig;
  services.swayidle = {
    enable = true;
    package = customPkgs.swayidle-wrapped.override {
      lockCmd = "${lib.getExe swaylock-script} -f";
    };
    systemdTargets = [ "niri.service" ];
  };
  programs.waybar = {
    enable = true;
    package = customPkgs.waybar-wrapped.override {
      thermal-zone = 6;
    };
    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };
  };
}

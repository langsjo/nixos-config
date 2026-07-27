{
  lib,
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
  niri-wrapped' = customPkgs.niri-wrapped.override {
    firefox = firefox-script;
    swaylock = swaylock-script;
  };
  niri-wrapped-nixGL' = customPkgs.niri-wrapped-nixGL.override {
    niri-wrapped = niri-wrapped';
  };
in
{
  home.packages = [
    niri-wrapped-nixGL'
  ];
  systemd.user.packages = [ niri-wrapped-nixGL' ];

  services.swayidle = {
    enable = true;
    package = customPkgs.swayidle-wrapped.override {
      lockCmd = "${lib.getExe swaylock-script} -f";
    };
    systemdTargets = [ "niri.service" ];
  };
  programs.waybar = {
    enable = true;
    package = customPkgs.waybar-wrapped;
    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };
  };
}

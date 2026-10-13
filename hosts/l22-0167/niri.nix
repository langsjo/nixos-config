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

  # for whatever reason, the xwayland-satellite from Nixpkgs doesn't work.
  xwayland-satellite-script = pkgs.writeShellScriptBin "xwayland-satellite-proxy" ''
    unset LD_LIBRARY_PATH
    exec /usr/local/bin/xwayland-satellite "$@"
  '';

  niri-script = pkgs.writeShellScript "niri-opener-proxy" ''
    exec /opt/niri "$@"
  '';

  niri-wrapped = (
    customPkgs.niri-wrapped.override {
      firefox = firefox-script;
      swaylock = swaylock-script;
      kitty-wrapped = lib.findFirst (x: x.pname or x.name == "kitty-nixGL") null config.home.packages;
      xwayland-satellite = xwayland-satellite-script;

      xcursor-size = 16;

      preBuild = ''
        rm $out/bin/niri
        cp ${niri-script} $out/bin/niri
      '';
    }
  );
in
{
  home.packages = [ niri-wrapped ];
  systemd.user.packages = [ niri-wrapped ];
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

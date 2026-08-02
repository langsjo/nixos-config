{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.windowManager.niri;
  niri-session = lib.getExe' config.programs.niri.package "niri-session";
in
{
  options.custom.gui.windowManager.niri.enable = lib.mkEnableOption "niri window-manager";

  config = lib.mkIf cfg.enable {
    custom = {
      wrappers.niri = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.niri-wrapped;
      gui = {
        waybar.enable = true;
        swayidle = {
          enable = true;
          targets = [ "niri.service" ];
        };
      };
    };

    services.dunst.enable = true;
    programs.niri = {
      enable = true;
      package = config.custom.wrappers.niri;
    };

    security.pam.services.greetd = {
      u2fAuth = true;
      rules.auth.u2f = {
        order = 10900;
        settings.pinverification = 1;
      };
    };

    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd '${niri-session}'";
          user = "greeter";
        };
        initial_session = {
          command = niri-session;
          user = config.custom.user.username;
        };
      };
    };
  };
}

{
  myPkgs,
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
  options.custom.gui.windowManager.niri = {
    enable = lib.mkEnableOption "niri window-manager";
    autoLogin = lib.mkEnableOption "niri autologin";
  };
  config = lib.mkIf cfg.enable {
    custom = {
      wrappers.niri = myPkgs.niri-wrapped;
      gui = {
        waybar = {
          enable = true;
          target = "niri.service";
        };
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

    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd '${niri-session}'";
          user = "greeter";
        };
        initial_session = lib.mkIf cfg.autoLogin {
          command = niri-session;
          user = config.custom.user.username;
        };
      };
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.gui.windowManager.dwm;
in
{
  config = lib.mkIf cfg.enable {
    # dwm-status.service fails on boot, but works afterwards. make it restart
    systemd.user.services.dwm-status = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    services.dwm-status = {
      enable = true;
      order = [
        "audio"
      ]
      ++ lib.optionals config.custom.isLaptop [
        "backlight"
        "battery"
      ]
      ++ [
        "cpu_load"
        "time"
      ];

      # settings = {
      #   separator = "    ";
      #
      #   audio = {
      #     mute = "";
      #     template = "   {ICO} {VOL}%";
      #     icons = ["󰕿" "󰖀" "󰕾"];
      #   };
      #
      #   backlight = {
      #     template = "{ICO} {BL}%";
      #     icons = ["󰃞" "󰃟" "󰃠"];
      #   };
      #
      #   battery = {
      #     discharging = "";
      #     charging = "";
      #     no_battery = "";
      #     icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
      #
      #     enable_notifier = true;
      #     notifier_levels = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25];
      #   };
      #
      #   cpu_load = {
      #     template = " {CL1}";
      #     update_interval = 10;
      #   };
      #
      #   time = {
      #     format = "󰥔 %H:%M %d.%m.%Y";
      #     update_seconds = false;
      #   };
      # };

      extraConfig = # TOML
        ''
          separator = "    "

          [audio]
          mute = ""
          template = "   {ICO} {VOL}%"
          icons = ["󰕿", "󰖀", "󰕾"]

          [backlight]
          template = "{ICO} {BL}%"
          icons = ["󰃞", "󰃟", "󰃠"]

          [battery]
          discharging = ""
          charging = ""
          no_battery = ""
          icons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

          enable_notifier = true
          notifier_levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]

          [cpu_load]
          template = " {CL1}"
          update_interval = 10

          [time]
          format = "󰥔 %H:%M %d.%m.%Y"
          update_seconds = false
        '';
    };
  };
}

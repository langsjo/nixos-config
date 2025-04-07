{ pkgs, ... }: {

  home.packages = with pkgs; [
    alsa-utils
  ];

  systemd.user.services.dwm-status = {
    Service.Restart = "on-failure";
  };

  services.dwm-status = {
    enable = true;
    order = [ "audio" "backlight" "battery" "cpu_load" "time" ];


    extraConfig = {
      separator = "    ";

      audio = {
        mute = "";
        template = "   {ICO} {VOL}%";
        icons = ["󰕿" "󰖀" "󰕾"];
      };

      backlight = {
        template = "{ICO} {BL}%";
        icons = ["󰃞" "󰃟" "󰃠"];
      };

      battery = {
        discharging = "";
        charging = "";
        no_battery = "";
        icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];

        enable_notifier = true;
        notifier_levels = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25];
      };

      cpu_load = {
        template = " {CL1}";
        update_interval = 10;
      };

      time = {
        format = "󰥔 %H:%M %d.%m.%Y";
        update_seconds = false;
      };
    };
  };
}

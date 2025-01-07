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
        notifier_levels = [25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];
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

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
        notifier_levels = [20 15 10 5 2];
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

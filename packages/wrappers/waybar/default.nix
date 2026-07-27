{
  lib,
  systemdSupport ? true, # required arg for waybar nixos module...
  waybar,
  playerctl,
  pavucontrol,
  writeShellScript,
  tlp-pd,
}:
let
  pctl = lib.getExe playerctl;
  tlpctl = lib.getExe' tlp-pd "tlpctl";
in
{
  package = waybar.override { inherit systemdSupport; };
  flags.path = {
    "--config"."/".json = {
      layer = "top";
      position = "bottom";
      height = 32;
      spacing = 6;

      modules-left = [
        "group/niri-group"
        "custom/media-prev"
        "mpris"
        "custom/media-next"
      ];
      modules-center = [ ];
      modules-right = [
        "pulseaudio"
        "backlight"
        "battery"
        "cpu"
        "temperature"
        "custom/power-profile"
        "clock"
      ];

      "group/niri-group" = {
        modules = [
          "niri/workspaces"
          "niri/window"
        ];
        orientation = "horizontal";
      };

      "niri/workspaces" = {
        format = "{value}";
      };
      "niri/window" = {
        format = "{title}";
        max-length = 27;
        ellipsis = "…";
      };

      mpris = {
        interval = 1;
        format = "{title}  {position}/{length}";
        format-paused = "{title}  {position}/{length}";
        format-stopped = "";
        title-len = 25;
        artist-len = 0;
        album-len = 0;
        ellipsis = "…";
        tooltip-format = "{title}\n{artist} — {album}\n{position}/{length}";
        on-click = "${pctl} play-pause";
      };
      "custom/media-prev" = {
        exec = "${pctl} status >/dev/null && echo '⏮'";
        interval = 5;
        on-click = "${pctl} previous";
        tooltip = false;
      };
      "custom/media-next" = {
        exec = "${pctl} status >/dev/null && echo '⏭'";
        interval = 5;
        on-click = "${pctl} next";
        tooltip = false;
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " 0%";
        format-icons = {
          headphone = "";
          default = [
            ""
            ""
          ];
        };
        on-click = lib.getExe pavucontrol;
        tooltip-format = "{desc}";
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = [ "" ];
        tooltip = false;
      };

      battery = {
        interval = 30;
        states = {
          warning = 25;
          critical = 15;
        };
        format = "{icon} {capacity}% ({time})";
        format-charging = " {capacity}% ({time})";
        format-full = " {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        tooltip = false;
      };

      cpu = {
        interval = 2;
        format = " {usage}%";
        tooltip = true;
      };

      "custom/power-profile" = {
        exec = writeShellScript "get-power-profile" ''
          profile=$("${tlpctl}" get 2>/dev/null)
          case "$profile" in
            "performance") icon= ;;
            "balanced")    icon= ;;
            "power-saver") icon= ;;
          esac
          echo "$icon  $profile"
        '';
        interval = 2;
        menu = "on-click";
        menu-actions = {
          balanced = "'${tlpctl}' balanced";
          performance = "'${tlpctl}' performance";
          power-saver = "'${tlpctl}' power-saver";
        };
        tooltip = false;
        menu-file = ./power-profile-menu.xml;
      };

      temperature = {
        interval = 5;
        warning-threshold = 70;
        critical-threshold = 85;
        format = " {temperatureC}°C";
        tooltip = false;
      };

      clock = {
        interval = 1;
        format = " {:%Y-%m-%d (%a) %H:%M:%S}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          format = {
            today = "<b>{}</b>";
          };
        };
      };
    };
    "--style"."/".source = ./style.css;
  };
}

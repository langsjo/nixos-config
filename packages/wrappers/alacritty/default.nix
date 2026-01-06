{
  alacritty,
  screenDpi ? 96,
}:
let
  fontSizePixels = 17.6;
in
{
  package = alacritty;
  flags.path = {
    "--config-file"."/".toml = {
      general.import = [
        ./alacritty-catppuccin-mocha.toml
      ];

      env.TERM = "xterm-256color";
      window = {
        decorations = "none";
        dynamic_padding = false;
        opacity = 1;
      };

      font = {
        # Font size calculation for 16px font on screen's DPI
        # One point is 1/72 of an inch
        # ${fontSizePixels} pixels * 72 inch^-1 / (${dpi} pixels / inch) = font size in points
        size = fontSizePixels * 72.0 / screenDpi;
        bold = {
          family = "MesloLGM Nerd Font";
          style = "Heavy";
        };

        bold_italic = {
          family = "MesloLGM Nerd Font";
          style = "Heavy Italic";
        };

        italic = {
          family = "MesloLGM Nerd Font";
          style = "Medium Italic";
        };

        normal = {
          family = "MesloLGM Nerd Font";
          style = "Medium";
        };
      };

      colors.normal = {
        green = "#00AA00";
        red = "#FF0000";
        yellow = "#DDDD00";
        blue = "#1144CC";
        magenta = "#AA00AA";
        cyan = "#00AAAA";
        white = "#DDDDDD";
      };
    };
  };
}

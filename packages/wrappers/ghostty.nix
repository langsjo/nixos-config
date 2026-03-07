{
  ghostty,
  formats,
}:
{
  package = ghostty;

  flags.path = {
    "--config-file="."/".generate = {
      format = formats.keyValue { };
      value = {
        window-decoration = false;
        window-padding-x = 0;
        window-padding-y = 0;
        confirm-close-surface = false;

        font-size = "13";
        font-family = "MesloLGM Nerd Font";
      };
    };
    "--theme="."/".text = ''
      background = #1e1e2e
      foreground = #cdd6f4
      cursor-color = #f5e0dc
      cursor-text = #1e1e2e
      selection-background = #f5e0dc
      selection-foreground = #1e1e2e

      palette = 0=#45475a
      palette = 1=#FF0000
      palette = 2=#00AA00
      palette = 3=#DDDD00
      palette = 4=#1144CC
      palette = 5=#AA00AA
      palette = 6=#00AAAA
      palette = 7=#DDDDDD
      palette = 8=#585b70
      palette = 9=#f38ba8
      palette = 10=#a6e3a1
      palette = 11=#f9e2af
      palette = 12=#89b4fa
      palette = 13=#f5c2e7
      palette = 14=#94e2d5
      palette = 15=#a6adc8
    '';
  };
}

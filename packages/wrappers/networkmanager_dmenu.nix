{
  lib,
  networkmanager_dmenu,
  fuzzel,
  dmenuCmd ? "${lib.getExe fuzzel} --dmenu --width 50",
}:
{
  package = networkmanager_dmenu;
  useBinaryWrapper = true;
  flags.path."--config"."/".text = ''
    [dmenu]
      dmenu_command = ${dmenuCmd}
      highlight = True
      wifi_chars = ▂▄▆█
      wifi_icons = 󰤯󰤟󰤢󰤥󰤨
  '';
}

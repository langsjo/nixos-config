{
  networkmanager_dmenu,
}:
{
  package = networkmanager_dmenu;
  useBinaryWrapper = true;
  flags.path."--config"."/".text = ''
    [dmenu]
      dmenu_command = rofi -dmenu -width 30 -i
      highlight = True 
      wifi_chars = ▂▄▆█
      wifi_icons = 󰤯󰤟󰤢󰤥󰤨
  '';
}

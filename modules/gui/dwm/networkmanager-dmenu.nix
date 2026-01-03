{
  wrappers.networkmanager_dmenu = {
    expose = false;

    flags.path."--config"."/".text = ''
      [dmenu]
        dmenu_command = rofi -dmenu -width 30 -i
        highlight = True 
        wifi_chars = ▂▄▆█
        wifi_icons = 󰤯󰤟󰤢󰤥󰤨
    '';
  };
}

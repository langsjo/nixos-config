{ pkgs, ... }: {
  home.packages = [
    pkgs.networkmanager_dmenu
  ];

  home.file = {
    ".config/networkmanager-dmenu/config.ini".text = ''
      [dmenu]
        dmenu_command = rofi -dmenu -width 30 -i
        highlight = True 
        wifi_chars = ▂▄▆█
        wifi_icons = 󰤯󰤟󰤢󰤥󰤨
    '';
  };
}

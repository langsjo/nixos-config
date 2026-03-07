{
  kitty,
  vimPlugins,
}:
{
  package = kitty;

  env.paths."KITTY_CONFIG_DIRECTORY" = {
    "kitty.conf".text = /* kitty */ ''
      hide_window_decorations yes
      window_padding_width    0
      window_border_width     0
      window_margin_width     0
      confirm_os_window_close 0
      placement_strategy      top-left

      font_family      family="MesloLGM Nerd Font"
      bold_font        auto
      italic_font      auto
      bold_italic_font auto
      font_size        13.0

      enable_audio_bell no

      allow_remote_control  socket-only
      listen_on             unix:@mykitty
      shell_integration     enabled

      action_alias                  kitty_scrollback_nvim kitten '${vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py'
      map                           kitty_mod+h kitty_scrollback_nvim
      map                           kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
      mouse_map                     ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
      scrollback_pager_history_size 3

      cursor_blink_interval 0

      background            #1e1e2e
      foreground            #cdd6f4
      cursor                #f5e0dc
      cursor_text_color     #1e1e2e
      selection_background  #f5e0dc
      selection_foreground  #1e1e2e

      color0  #45475a
      color1  #FF0000
      color2  #00AA00
      color3  #DDDD00
      color4  #1144CC
      color5  #AA00AA
      color6  #00AAAA
      color7  #DDDDDD
      color8  #585b70
      color9  #f38ba8
      color10 #a6e3a1
      color11 #f9e2af
      color12 #89b4fa
      color13 #f5c2e7
      color14 #94e2d5
      color15 #a6adc8
    '';

    "open-actions.conf".text = /* kitty */ ''
      protocol file
      mime text/*
      action launch --type=overlay -- sh -c 'exec nvim --cmd "cd ''${1%/*}"  "$1"' -- $FILE_PATH
    '';
  };
}

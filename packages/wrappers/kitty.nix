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
      window_margin_width     0
      confirm_os_window_close 1
      placement_strategy      top-left

      font_family      family="MesloLGM Nerd Font"
      bold_font        auto
      italic_font      auto
      bold_italic_font auto
      font_size        13.0

      enable_audio_bell no

      allow_remote_control  yes
      listen_on             unix:@mykitty
      shell_integration     enabled

      action_alias                  kitty_scrollback_nvim kitten '${vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py'
      map                           kitty_mod+h kitty_scrollback_nvim
      map                           kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
      mouse_map                     ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
      scrollback_pager_history_size 3

      map alt+ctrl+h   previous_tab
      map alt+ctrl+l   next_tab
      map alt+ctrl+j   move_tab_backward
      map alt+ctrl+k   move_tab_forward

      action_alias  kitty_navigator_nvim kitten '${vimPlugins.vim-kitty-navigator}/pass_keys.py'
      map           ctrl+j kitty_navigator_nvim bottom ctrl+j
      map           ctrl+k kitty_navigator_nvim top    ctrl+k
      map           ctrl+h kitty_navigator_nvim left   ctrl+h
      map           ctrl+l kitty_navigator_nvim right  ctrl+l

      map ctrl+space>c          new_tab_with_cwd
      map ctrl+space>shift+2    launch --location=hsplit --cwd=current
      map ctrl+space>shift+5    launch --location=vsplit --cwd=current

      enabled_layouts splits,stack

      window_border_width     1pt
      active_border_color     #89b4fa
      inactive_border_color   #45475a

      tab_bar_edge              bottom
      tab_bar_margin_height     5.0 0.0
      tab_bar_style             separator
      tab_separator             ""
      tab_bar_min_tabs          1
      tab_title_template        "{fmt.bg._89b4fa}{fmt.fg._1e1e2e} {index} {fmt.bg.tab}{fmt.fg.tab} {tab.active_exe:<3.20} {bell_symbol}"
      active_tab_title_template "{fmt.bg._fab387}{fmt.fg._1e1e2e} {index} {fmt.bg.tab}{fmt.fg.tab} {(('/'.join(tab.active_wd.split('/')[-2:]) + f" {bell_symbol}") if tab.active_wd else title):<3}"
      active_tab_foreground     #ffffff
      active_tab_background     #3a3a3a
      inactive_tab_foreground   #ffffff
      inactive_tab_background   #313244
      tab_bar_background        #1e1e2e

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

    "open-actions.conf".text =
      let
        nvimAction = ''
          launch --type=overlay -- sh -c 'exec nvim --cmd "cd ''${1%/*}"  "$1"' -- $FILE_PATH
        '';
      in
      /* kitty */ ''
        protocol file
        mime text/*
        action ${nvimAction}

        protocol file
        mime inode/directory
        action launch --type=overlay -- yazi -- $FILE_PATH

        # Any file without an extension
        protocol file
        url ^file://.*/[^.]+$
        action ${nvimAction}
      '';
  };
}

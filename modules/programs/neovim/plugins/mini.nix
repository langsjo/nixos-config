{
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {
        # better around/inside
        ai = {
          n_lines = 500;
        };

        surround = {};

        # vimium type navigation of lines
        # jump2d = {
        #   view = {
        #     dim = true;
        #     n_steps_ahead = 0;
        #   };
        #
        #   allowed_lines = {
        #     blank = false;
        #     cursor_before = true;
        #     cursor_at = true;
        #     cursor_after = true;
        #     fold = false;
        #   };
        #
        #   allowed_windows = {
        #     current = true;
        #     not_current = false;
        #   };
        # };

        statusline = {
          use_icons.__raw = "vim.g.have_nerd_font";
        };
      };
    };

      # set statusline cursor location to line:column
      extraConfigLua = ''
        require('mini.statusline').section_location = function()
          return '%2l:%-2v'
        end
      '';
  };
}

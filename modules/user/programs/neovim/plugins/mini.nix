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

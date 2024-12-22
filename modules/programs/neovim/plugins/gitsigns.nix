{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      settings.signs = {
        add = {text = "+";};
        change = {text = "~";};
        delete = {text = "_";};
        topdelete = {text = "‾";};
        changedelete = {text = "~";};
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>hb";
        action.__raw = ''
          function()
            require('gitsigns').blame_line()
          end
        '';
        options = {
          desc = "git [b]lame line";
        };
      }
    ];
  };
}

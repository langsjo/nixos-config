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

      {
        mode = "v";
        key = "<leader>hs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
          '';
        options = {
          desc = "git [s]tage hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>ht";
        action.__raw = ''
          function()
            require('gitsigns').toggle_current_line_blame()
          end
        '';
        options = {
          desc = "[T]oggle git show [b]lame line";
        };
      }
    ];
  };
}

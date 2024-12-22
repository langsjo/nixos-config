{ pkgs, inputs, ... }: {

  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./plugins
  ];

  config = {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      colorschemes = {
        tokyonight = {
          enable = true;
          settings.style = "night";
        };
      };

      globals = {
        mapleader = ",";
        maplocalleader = ",";

        have_nerd_font = true;
      };

      opts = {
        mouse = "a";
        showmode = false;
        undofile = true;
        hlsearch = true;
        title = true;
        inccommand = "split"; # preview search and replace
        signcolumn = "yes"; # stops screen from shifting when lsp errors load

        updatetime = 1000; # milliseconds of inaction till swap file is written
        timeoutlen = 500; # milliseconds till which-key pops up

        number = true;
        relativenumber = true;

        splitright = true;
        splitbelow = true;

        expandtab = true;
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        breakindent = true;

        ignorecase = true;
        smartcase = true;

        list = true;
        listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

        cursorline = true;
        scrolloff = 10; # lines to keep on top/bottom of screen while scrolling

        clipboard = {
          providers.xsel.enable = true;
          register = "unnamedplus";
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>noh<CR>";
        }
        # Move selected lines up/down
        {
          mode = "v";
          key = "J";
          action = "<CMD>undojoin<CR>:m '>+1<CR>gv=gv";
        }
        {
          mode = "v";
          key = "K";
          action = "<CMD>undojoin<CR>:m '<-2<CR>gv=gv";
        }

        # Entering visual line mode breaks the last undo sequence so the moving lines up/down can be undone in one undo, since theyre joined together
        {
          mode = "n";
          key = "V";
          action = "aa<BS><ESC>V";
        }

        {
          mode = [ "n" "v" ];
          key = "j";
          action = "gj";
        }
        {
          mode = [ "n" "v" ];
          key = "k";
          action = "gk";
        }

        # Tab related binds
        {
          mode = "n";
          key = "H";
          action = "<cmd>tabprevious<cr>";
        }
        {
          mode = "n";
          key = "L";
          action = "<cmd>tabnext<cr>";
        }
        {
          mode = "n";
          key = "<C-Right>";
          action = "<cmd>+tabm<cr>";
        }
        {
          mode = "n";
          key = "<C-Left>";
          action = "<cmd>-tabm<cr>";
        }
        {
          mode = "n";
          key = "<PageUp>";
          action = "<C-w>>";
        }
        {
          mode = "n";
          key = "<PageDown>";
          action = "<C-w><";
        }
      ];

      plugins = {
        web-devicons.enable = true; # icons for plugins
        sleuth.enable = true; # detect tabsize automatically

        todo-comments.settings = {
          enable = true;
          signs = false;
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        nvim-web-devicons # more icons
      ];

      extraConfigLuaPre = ''
        if vim.g.have_nerd_font then
          require('nvim-web-devicons').setup {}
        end
      '';

      autoGroups = {
        highlight-yank = {
          clear = true;
        };
      };

      autoCmd = [
        {
          event = [ "TextYankPost" ];
          desc = "Highlight when yanking text";
          group = "highlight-yank";

          callback.__raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        }
      ];

      files = {
        "ftplugin/nix.lua".opts = {
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
        };
      };

    };
  };
}

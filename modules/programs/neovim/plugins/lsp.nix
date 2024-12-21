{ pkgs, ... }: {
  programs.nixvim = {
    plugins.cmp-nvim-lsp.enable = true;
    plugins.fidget.enable = true;
    plugins.lsp-format.enable = true;

    autoGroups = {
      "lsp-attach" = {
        clear = true;
      };
    };

    plugins.lsp = {
      enable = true;

      servers = {
        clangd.enable = true;
        nixd.enable = true;
        pylsp.enable = true;
        metals.enable = true;
        lua_ls.enable = true;
      };

      keymaps = {
        diagnostic = {
          "<leader>q" = {
            action = "setloclist";
            desc = "Open diagnostic [Q]uickfix list";
          };
        };

        extra = [
          {
            mode = "n";
            key = "gd";
            action.__raw = "require('telescope.builtin').lsp_definitions";
            options = {
              desc = "LSP: [G]oto [D]efinition";
            };
          }

          {
            mode = "n";
            key = "gr";
            action.__raw = "require('telescope.builtin').lsp_references";
            options = {
              desc = "LSP: [G]oto [R]eferences";
            };
          }

          {
            mode = "n";
            key = "gI";
            action.__raw = "require('telescope.builtin').lsp_implementations";
            options = {
              desc = "LSP: [G]oto [I]mplementation";
            };
          }

          {
            mode = "n";
            key = "<leader>D";
            action.__raw = "require('telescope.builtin').lsp_type_definitions";
            options = {
              desc = "LSP: Type [D]efinition";
            };
          }

          {
            mode = "n";
            key = "<leader>ds";
            action.__raw = "require('telescope.builtin').lsp_document_symbols";
            options = {
              desc = "LSP: [D]ocument [S]ymbols";
            };
          }

          {
            mode = "n";
            key = "<leader>ws";
            action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
            options = {
              desc = "LSP: [W]orkspace [S]ymbols";
            };
          }
        ];

        lspBuf = {
          "<leader>rn" = {
            action = "rename";
            desc = "LSP: [R]e[n]ame";
          };

          "<leader>ca" = {
            action = "code_action";
            desc = "LSP:[C]ode [A]ction";
          };

          "K" = {
            action = "hover";
            desc = "LSP: Hover";
          };
        };
      };
    };
  };
}

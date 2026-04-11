{
  config,
  lib,
  pkgs,
  ...
}:
let
  fft = config.plugins.conform-nvim.settings.formatters_by_ft;
in
{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = lib.mkMerge [
        {
          formatters_by_ft.nix = [ "nixfmt" ];
          formatters.nixfmt.command = lib.getExe pkgs.nixfmt;
        }
        {
          formatters_by_ft.python = [
            "ruff_format"
            "ruff_fix"
            "ruff_organize_imports"
          ];
          formatters = lib.genAttrs fft.python (formatter: {
            command = lib.getExe pkgs.ruff;
          });
        }
        {
          format_on_save.__raw = ''
            function(bufnr)
              local buf = vim.b[bufnr]
              local autoformat_enabled =
                buf.enable_autoformat == true
                or (vim.g.enable_autoformat and buf.enable_autoformat ~= false)
              if autoformat_enabled then
                return { timeout_ms = 500, lsp_format = "fallback" }
              end
              return
            end
          '';
        }
      ];
    };
    mini-trailspace.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tf";
      options.desc = "Toggle global autoformatting";
      action.__raw = ''
        function()
          if vim.g.enable_autoformat then
            vim.cmd "FormatDisable"
            vim.notify "Disabled autoformat globally"
          else
            vim.cmd "FormatEnable"
            vim.notify "Enabled autoformat globally"
          end
        end
      '';
    }
    {
      mode = "n";
      key = "<leader>tF";
      options.desc = "Toggle autoformatting for current buffer";
      action.__raw = ''
        function()
          if vim.b.enable_autoformat then
            vim.cmd "FormatDisable!"
            vim.notify "Disabled autoformat for current buffer"
          else
            vim.cmd "FormatEnable!"
            vim.notify "Enabled autoformat for current buffer"
          end
        end
      '';
    }
  ];

  userCommands = {
    "FormatDisable" = {
      desc = "Disable autoformat-on-save";
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.enable_autoformat = false
          else
            vim.g.enable_autoformat = false
          end
        end
      '';
    };
    "FormatEnable" = {
      desc = "Re-enable autoformat-on-save";
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.enable_autoformat = true
          else
            vim.g.enable_autoformat = true
          end
        end
      '';
    };
  };
  autoCmd = [
    {
      event = [ "BufWritePre" ];
      desc = "Remove trailing whitespace on write";
      callback.__raw = ''
        function()
          require('mini.trailspace').trim()
        end
      '';
    }
  ];
}

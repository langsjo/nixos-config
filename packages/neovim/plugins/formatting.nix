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
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 500, lsp_format = "fallback" }
            end
          '';
        }
      ];
    };
    mini-trailspace.enable = true;
  };

  extraConfigLua = ''
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  '';

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

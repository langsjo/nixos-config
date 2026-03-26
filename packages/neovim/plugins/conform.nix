{
  lib,
  pkgs,
  ...
}:
let
  formatters = {
    nix = pkgs.nixfmt;
  };

  conformConfig = {
    formatters_by_ft = builtins.mapAttrs (_: package: [ (lib.getName package) ]) formatters;
    formatters = lib.mapAttrs' (_: package: {
      name = lib.getName package;
      value.command = lib.getExe package;
    }) formatters;
  };
in
{
  plugins.conform-nvim = {
    enable = true;
    settings = conformConfig // {
      format_on_save.__raw = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
            return { timeout_ms = 500, lsp_format = "fallback" }
        end
      '';
    };
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
}

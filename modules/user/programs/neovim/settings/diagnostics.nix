let
  diagnosticsConfigLua = ''
    {
      severity_sort = true,
      virtual_lines = {
          format = function(diagnostic)
              return diagnostic.message
          end,
      },
    }
  '';
in
{
  programs.nixvim = {
    diagnostic.settings = {
      # Have virtual lines off by default, enable with a toggle
      virtual_lines = false;
    };
    keymaps = [
      {
        # Toggle virtual text and virtual lines
        mode = "n";
        key = "<leader>xc";
        action.__raw = ''
          function()
            local c = vim.diagnostic.config()
            if not c.virtual_lines then
              vim.diagnostic.config(${diagnosticsConfigLua})
            else
              vim.diagnostic.config({
                virtual_lines = false,
              })
            end
          end
        '';
        options = {
          desc = "Toggle virtual lines";
        };
      }
    ];
  };
}

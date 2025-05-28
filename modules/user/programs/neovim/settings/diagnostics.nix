{
  programs.nixvim = {
    diagnostic.settings = {
      virtual_lines = {
        # Use virtual lines for errors
        severity.min.__raw = "vim.diagnostic.severity.ERROR";

        # Only show the diagnostic message, not the name of the error
        format.__raw = ''
          function(diagnostic)
            return diagnostic.message
          end
        '';
      };

      virtual_text = {
        # and virtual text for anything else
        severity.max.__raw = "vim.diagnostic.severity.WARN";

        # Only show the diagnostic message, not the name of the error
        format.__raw = ''
          function(diagnostic)
            return diagnostic.message
          end
        '';
      };

      severity_sort = true;
    };

    keymaps = [
      {
        # Toggle virtual text and virtual lines
        mode = "n";
        key = "<leader>xc";
        action.__raw = ''
          function()
            local c = vim.diagnostic.config()
            vim.diagnostic.config({
              virtual_text = not c.virtual_text,
              virtual_lines = not c.virtual_lines,
            })
          end
        '';
      }
    ];
  };
}

{
  programs.nixvim = {
    plugins.luasnip.enable = true;

    plugins.cmp = {
      enable = true;

      settings = {
        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };

        completion.completeopt = "menu,menuone,noinsert";

        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-f>" = "cmp.mapping.confirm { select = true }";

          # Scroll the documentation window [b]ack / [f]orward
          "<C-e>" = "cmp.mapping.scroll_docs(-4)";
          "<C-y>" = "cmp.mapping.scroll_docs(4)";

          "<C-l>" = ''
            cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' })
          '';
          "<C-h>" = ''
            cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' })
          '';
        };

        autoEnableSources = true;
        sources = [
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "calc"; }
          { name = "buffer"; }
        ];
      };

      cmdline = {
        ":" = {
          mapping = {
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'c'})";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'c'})";
            "<C-f>" = "cmp.mapping(cmp.mapping.confirm { select = true }, {'c'})";
          };

          sources = [
            { name = "path"; }
            { name = "cmdline"; }
          ];
        };
      };

      
    };
  };
}

{
  imports = [
    ./neotree.nix
    ./debug.nix
    ./formatting.nix
    ./autopairs.nix
    ./treesitter.nix
    ./telescope.nix
    ./which-key.nix
    ./lsp.nix
    ./cmp.nix
    ./mini.nix
    ./leap.nix
    ./gitsigns.nix
  ];

  # Small configurations here
  plugins = {
    indent-blankline.enable = true;
    comment.enable = true;
    markdown-preview.enable = true;
    image.enable = true;

    kitty-scrollback.enable = true;
    kitty-navigator.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ti";
      options.desc = "Toggle images";
      action.__raw = ''
        function()
          image = require("image")
          if image.is_enabled() then
            image.disable()
            vim.notify "Disabled images"
          else
            image.enable()
            vim.notify "Enabled images"
          end
        end
      '';
    }
  ];

  extraConfigVim = ''
    packadd nvim.undotree
  '';
}

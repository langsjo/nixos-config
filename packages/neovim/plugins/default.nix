{
  imports = [
    ./neotree.nix
    ./debug.nix
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

    kitty-scrollback.enable = true;
    kitty-navigator.enable = true;
  };
}

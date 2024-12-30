{ ... }: {
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
  programs = {
    ripgrep.enable = true;
    nixvim.plugins = {
      indent-blankline.enable = true;
      comment.enable = true;

      tmux-navigator = {
        enable = true;
        settings.no_wrap = 1;
      };
    };
  };
}

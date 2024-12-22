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
    ./tmux-navigator.nix
  ];

  programs = {
    ripgrep.enable = true;
    nixvim.plugins = {
      indent-blankline.enable = true;
    };
  };
}

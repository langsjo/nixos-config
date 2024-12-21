{ pkgs, ... }: {
  imports = [
    ./oneliners.nix
    ./neotree.nix
    ./debug.nix
    ./autopairs.nix
    ./treesitter.nix
    ./telescope.nix
    ./which-key.nix
    ./lsp.nix
    ./cmp.nix
  ];
}

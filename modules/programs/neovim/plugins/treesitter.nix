{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
  };
}

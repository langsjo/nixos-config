{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
    };

    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
      }
    ];
  };
}

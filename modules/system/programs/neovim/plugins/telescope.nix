{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      extensions = {
        fzf-native.enable = true;
        ui-select.enable = true;
      };

      keymaps = {
        "<leader>sf" = {
          mode = "n";
          action = "find_files";
          options.desc = "[S]earch [F]iles";
        };

        "<leader>sg" = {
          mode = "n";
          action = "live_grep";
          options.desc = "[S]earch by [G]rep";
        };

        "<leader>sw" = {
          mode = "n";
          action = "grep_string";
          options.desc = "[S]earch current [W]ord";
        };

        "<leader>sr" = {
          mode = "n";
          action = "resume";
          options.desc = "[S]earch [R]esume";
        };

        "<leader><leader>" = {
          mode = "n";
          action = "buffers";
          options.desc = "[,] Find existing buffers";
        };
      };
    };
  };
}

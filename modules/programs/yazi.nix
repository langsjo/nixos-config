{
  pkgs,
  lib,
  ...
}:
{
  programs.yazi = {
    enable = true;
    settings = {
      yazi = {
        mgr = {
          ratio = [
            3
            5
            12
          ];

          sort_by = "natural";
          sort_sensitive = false;
          sort_dir_first = true;
          sort_translit = false;
          show_hidden = false;
          show_symlink = true;

          scrolloff = 10;
        };

        preview = {
          wrap = "no";
          max_width = 3000;
          max_height = 3000;
        };
      };

      keymap.mgr.prepend_keymap = [
        {
          on = "<C-n>";
          run = "shell -- ${lib.getExe pkgs.ripdrag} %s -x 2>/dev/null &";
          desc = "Drag and drop";
        }
      ];
    };
  };
}

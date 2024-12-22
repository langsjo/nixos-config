{
  programs.nixvim = {
    plugins.leap = {
      enable = true;
      addDefaultMappings = false;
    };

    keymaps = [
      {
        action = "<Plug>(leap)";
        key = "<CR>";
        mode = "n";
      }
      {
        # Remote leaps
        action.__raw = ''
          function()
            require('leap.remote').action()
          end
        '';
        key = "gs";
        mode = "n";
      }
    ];
  };
}

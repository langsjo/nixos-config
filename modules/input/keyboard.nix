{
  services = {
    xserver = {
      xkb = {
        layout = "fi";
        variant = "nodeadkeys";
      };
      autoRepeatDelay = 200;
      autoRepeatInterval = 33;
    };

    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];

        settings.main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };
}

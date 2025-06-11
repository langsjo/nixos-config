{
  services.xserver.xkb = {
    layout = "fi";
    variant = "nodeadkeys";
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];

      settings.main = {
        capslock = "overload(control, esc)";
      };
    };
  };
}

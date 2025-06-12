{
  services = {
    xserver.xkb = {
      layout = "fi";
      variant = "nodeadkeys";
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

    libinput = {
      enable = true;
      touchpad = {
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        tapping = false;
      };
    };
  };
}

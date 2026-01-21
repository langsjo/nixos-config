{
  services = {
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = true;
        naturalScrolling = true;
        accelProfile = "flat";
        accelSpeed = "0.5";
      };
      mouse.accelProfile = "flat";
    };
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Elan TrackPoint";
    sensitivity = 255;
    speed = 255;
  };
}

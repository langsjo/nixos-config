{
  services = {
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = true;
        accelProfile = "flat";
        accelSpeed = "0.5";
      };
      mouse.accelProfile = "flat";
    };
  };

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Elan TrackPoint";
    drift_time = 100;
    sensitivity = 255;
    speed = 255;
  };
}

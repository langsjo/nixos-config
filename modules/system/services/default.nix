{ ... }: {
  imports = [
    ./dwm.nix
    ./keyd.nix
  ];

  # small configs go here
  services = {
    openssh.enable = true;
    upower.enable = true;

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

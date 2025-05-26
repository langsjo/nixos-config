{ pkgs, ... }: {
  imports = [
    ./dwm.nix
    ./keyd.nix
    ./sxwm-module.nix
  ];

  environment.systemPackages = with pkgs; [
    # (callPackage ./sxwm.nix { })
  ];

  # small configs go here
  services = {
    openssh.enable = true;
    upower.enable = true;
    tlp.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        tapping = false;
      };
    };

    locate = {
      enable = true;
      package = pkgs.plocate;
    };

    xserver.windowManager.sxwm.enable = true;
  };

  powerManagement.powertop.enable = true;
}

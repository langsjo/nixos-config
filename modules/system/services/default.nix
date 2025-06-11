{ pkgs, ... }:
{
  imports = [
    ./dwm.nix
    ./keyboard.nix
    ./sxwm-module.nix
  ];

  environment.systemPackages = with pkgs; [
    # (callPackage ./sxwm.nix { })
  ];

  # small configs go here
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

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

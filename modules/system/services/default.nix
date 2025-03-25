{ pkgs, ... }: {
  imports = [
    ./dwm.nix
    ./keyd.nix
  ];

  environment.systemPackages = with pkgs; [
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
      localuser = null;
    };
  };

  powerManagement.powertop.enable = true;
}

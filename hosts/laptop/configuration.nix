{
  inputs,
  ...
}:
{
  imports =
    [
      ./hardware-configuration.nix
      "${inputs.self}/modules"
      inputs.home-manager.nixosModules.default
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
    ]);

  custom = {
    isLaptop = true;

    user = {
      username = "langsjo";
      homeDirectory = "/home/langsjo";
    };

    gui = {
      enable = true;
      programs.enable = true;

      displayManager.ly.enable = true;
      xserver.enable = true;
      windowManager.dwm = {
        enable = true;
        status.enable = true;
      };
    };

    screen.dpi = 141;

    home-manager = {
      enable = true;
      stateVersion = "24.11";
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics.enable = true;
    };
  };

  networking.hostName = "laptop";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

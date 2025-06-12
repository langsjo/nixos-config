{
  inputs,
  config,
  ...
}:
{
  imports =
    [
      ./hardware-configuration.nix
      "${inputs.self}/modules"
      inputs.home-manager.nixosModules.default
    ]
    ++ (with inputs.nixos-hardware; [
      nixosModules.common-cpu-intel-cpu-only
      (outPath + "/common/gpu/nvidia/pascal")
    ]);

  custom = {
    isLaptop = false;

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

    screen.dpi = 96;

    home-manager = {
      enable = true;
      stateVersion = "25.05";
    };

    gaming = {
      enable = true;
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics.enable = true;
    };
  };

  services.xserver = {
    xrandrHeads = [
      {
        output = "DP-4";
        primary = true;
      }
      {
        output = "HDMI-0";
      }
    ];

    resolutions = [
      { x = 1920; y = 1080; }
    ];

    dpi = config.custom.screen.dpi;
  };

  networking.hostName = "desktop";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/0b5f8011-e95b-4e7d-8a50-aeaaf8c721de";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "noatime"
      "nodiratime"
      "compress=zstd"
      "subvol=@nix"
    ];
  };
}

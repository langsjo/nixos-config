{
  inputs,
  myPkgs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${inputs.self}/modules"
  ]
  ++ (with inputs.nixos-hardware; [
    nixosModules.common-cpu-intel-cpu-only
    (outPath + "/common/gpu/nvidia/pascal")
  ]);
  # Pascal GPU not supported in 590+
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

  services.power-profiles-daemon.enable = true;

  custom = {
    isLaptop = false;

    virt.enable = false;

    user = {
      username = "langsjo";
      homeDirectory = "/home/langsjo";
    };

    gui = {
      enable = true;
      windowManager.niri = {
        enable = true;
      };
    };

    screen.dpi = 96;

    gaming = {
      enable = true;
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics.enable = true;
      gpuType = "nvidia";
    };

    wrappers = {
      waybar = lib.mkForce (
        myPkgs.waybar-wrapped.override {
          thermal-zone = 3;
        }
      );
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
      {
        x = 1920;
        y = 1080;
      }
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
}

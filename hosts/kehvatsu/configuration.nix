{
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${inputs.self}/modules"

    # Using lenovo-thinkpad-14-amd directly uses software iommu which we don't need
    "${inputs.nixos-hardware}/lenovo/thinkpad/e14"
    "${inputs.nixos-hardware}/common/cpu/amd"
    "${inputs.nixos-hardware}/common/gpu/amd"
  ];

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };

    extraModprobeConfig = ''
      options rtw89_pci disable_aspm_l1=y
    '';
  };

  custom = {
    isLaptop = true;

    user = {
      username = "langsjo";
      extraGroups = [ "dialout" ];
      homeDirectory = "/home/langsjo";
    };

    gui = {
      enable = true;
      programs.enable = true;

      displayManager.ly.enable = true;
      xserver.enable = true;
      windowManager.dwm = {
        enable = true;
      };
    };

    gaming.enable = true;

    screen.dpi = 162;

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      graphics.enable = true;
      gpuType = "amd";
    };
  };

  networking.hostName = "kehvatsu";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}

{
  pkgs,
  pkgs-unstable,
  inputs,
  config,
  ...
}:
{
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
    "${inputs.self}/modules/system"
    inputs.home-manager.nixosModules.default
  ];

  users.users.langsjo = {
    isNormalUser = true;
    description = "langsjo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    packages = with pkgs; [
      telegram-desktop
      rofi-screenshot
    ];
    shell = pkgs.zsh;
    useDefaultShell = true;
    ignoreShellProgramCheck = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users = {
      "langsjo" = import ./home.nix;
    };
  };

  zramSwap = {
    enable = true;
    priority = 9999;
    memoryPercent = 200;
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

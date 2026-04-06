{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./nm-profiles
    ./openssh.nix
  ];

  programs.nm-applet.enable = config.custom.gui.enable;
  networking.networkmanager = {
    enable = true;
    plugins = [
      pkgs.networkmanager-openconnect
    ];
  };
  custom.user.extraGroups = [ "networkmanager" ];
}

{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./nginx.nix
    ./exthdd.nix
    ./sshd.nix
    ../../modules
  ];

  services.logind.settings.Login.HandleLidSwitch = "ignore";
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  custom = {
    user = {
      shell = pkgs.bash;
    };

    gui.enable = false;
    providers.enable = false;
    virt.enable = false;
    gpg.enable = false;

    hardware = {
      audio.enable = false;
      bluetooth.enable = false;
      graphics.enable = false;
    };
    certs.enable = true;
    dyndns.enable = true;
    attic = {
      enable = true;
      domain = "cache.langsjo.dev";
      port = 9874;
    };
    headscale = {
      enable = true;
      domain = "headscale.langsjo.dev";
      port = 6521;
    };
    resticServer = {
      enable = true;
      domain = "restic.intra.langsjo.dev";
      port = 3987;
    };
    adguardhome = {
      enable = true;
      domain = "adguard.intra.langsjo.dev";
      httpPort = 2984;
      httpsPort = 2985;
    };

    programs = {
      enable = false;
      nvim.enable = true;
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:langsjo/nixos-config";
    dates = "18:00 Europe/Helsinki";
    upgrade = false;
    persistent = true;
    operation = "switch";
    allowReboot = false;
  };

  environment.systemPackages = with pkgs; [
    git
    btop
    dust
  ];

  system.stateVersion = "26.05";
}

{
  pkgs,
  inputs,
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
    "${inputs.nixos-hardware}/common/cpu/intel/ice-lake"
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
    gpg.enable = false;

    hardware = {
      audio.enable = false;
      bluetooth.enable = false;
      graphics.enable = false;
    };
    certs.enable = true;
    intrasites = {
      enable = true;
      bindIP = "100.64.0.2";
    };
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

    arr = {
      enable = true;
      qbittorrent = {
        torrentPort = 5843;
        webUIPort = 4387;
        webUIDomain = "qbit.intra.langsjo.dev";
      };
      jellyfin = {
        port = 8437;
        domain = "jelly.intra.langsjo.dev";
        hwAccDev = "/dev/dri/renderD128";
      };
      prowlarr = {
        port = 3928;
        domain = "prowlarr.intra.langsjo.dev";
      };
      radarr = {
        port = 3945;
        domain = "radarr.intra.langsjo.dev";
      };
      sonarr = {
        port = 8531;
        domain = "sonarr.intra.langsjo.dev";
      };
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
    vim
  ];

  system.stateVersion = "26.05";
}

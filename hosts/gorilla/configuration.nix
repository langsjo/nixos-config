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

    hardware = {
      audio.enable = false;
      bluetooth.enable = false;
      graphics.enable = false;
    };
    dyndns.enable = true;
    attic = {
      enable = true;
      domain = "cache.gorilla.gay";
      port = 9874;
    };
    headscale = {
      enable = true;
      domain = "headscale.gorilla.gay";
      port = 6521;
    };
    resticServer = {
      enable = true;
      domain = "restic.intra.gorilla.gay";
      port = 3987;
    };

    openssh.enable = true;
    programs = {
      enable = false;
      nvim.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    btop
    dust
  ];

  system.stateVersion = "26.05";
}

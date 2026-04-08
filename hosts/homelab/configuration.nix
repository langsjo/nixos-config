{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./nginx.nix
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
    attic.enable = true;
    dyndns.enable = true;
    headscale = {
      enable = true;
      domain = "headscale.gorilla.gay";
      port = 6521;
    };

    openssh.enable = true;
    programs = {
      enable = false;
      nvim.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "26.05";
}

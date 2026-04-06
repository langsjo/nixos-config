{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules
  ];

  services.logind.settings.Login.HandleLidSwitch = "ignore";
  custom = {
    user = {
      shell = pkgs.bash;
    };

    gui.enable = false;
    providers.enable = false;

    hardware = {
      audio.enable = false;
      bluetooth.enable = false;
      graphics.enable = false;
    };
    dyndns = {
      enable = true;
      domains = [
        "gorilla.gay"
        "*.gorilla.gay"
      ];
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

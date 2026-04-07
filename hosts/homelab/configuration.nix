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
    attic.enable = true;
    dyndns = {
      enable = true;
      domains = [
        "gorilla.gay"
      ];
    };

    openssh.enable = true;
    programs = {
      enable = false;
      nvim.enable = true;
    };
  };
  security.acme.acceptTerms = true;
  services.nginx = {
    enable = true;
    virtualHosts = {
      "gorilla.gay" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = "200 gorilloidaan\n";
          extraConfig = ''
            add_header Content-Type text/plain;
          '';
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "26.05";
}

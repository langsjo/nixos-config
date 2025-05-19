{ inputs, pkgs, ... }: {

  imports = [
  ];

  environment.systemPackages = with pkgs; [
    unzip
    zip
    comma
    btop
    nixpkgs-review
  ];

  programs = {
    steam.enable = true;
    slock.enable = true;
    light.enable = true;
    thunar.enable = true;
    nh = {
      enable = true;
      flake = inputs.self;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  virtualisation.docker.enable = true;
}

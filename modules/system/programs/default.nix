{ pkgs, ... }:
{

  imports = [
  ];

  environment.systemPackages = with pkgs; [
    unzip
    zip
    comma
    btop
    nixpkgs-review
    nix-output-monitor
  ];

  programs = {
    steam.enable = true;
    slock.enable = true;
    light.enable = true;
    thunar.enable = true;
  };

  virtualisation.docker.enable = true;
}

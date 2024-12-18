{ config, pkgs, inputs, ... }: {

  fonts.enableDefaultPackages = true;

  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];
}

{ pkgs, pkgs-unstable, ... }: {
  fonts.packages = [
    pkgs.liberation_ttf
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji

    pkgs-unstable.nerd-fonts.meslo-lg
  ];

  fonts.enableDefaultPackages = true;
}

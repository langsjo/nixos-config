{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.meslo-lg
  ];

  fonts.enableDefaultPackages = true;
}

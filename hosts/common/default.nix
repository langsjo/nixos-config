{ config, pkgs, inputs, ... }: {
  fonts.packages = with pkgs; [
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fonts.enableDefaultPackages = true;
}

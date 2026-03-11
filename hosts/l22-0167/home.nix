{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./providers.nix
    ./programs.nix
  ];

  _module.args.kehvatsu = inputs.self.nixosConfigurations.kehvatsu;

  news.display = "silent";
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.meslo-lg
  ];

  programs = {
    home-manager = {
      enable = true;
      path = lib.mkForce "${config.home.homeDirectory}/nixos";
    };
  };

  fonts.fontconfig.enable = true;

  home.username = "langsjr1";
  home.homeDirectory = "/u/94/langsjr1/unix";

  home.stateVersion = "26.05";
}

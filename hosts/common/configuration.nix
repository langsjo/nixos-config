{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    tree
    vim
    nix-prefetch-github
    wget
    xorg.libXft
    xsel
    wineWowPackages.stable
    libnotify
    dunst
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}

{ pkgs, pkgs-unstable, inputs, ... }: {
  imports = [
    ./neovim
    ./alacritty.nix
    ./zsh.nix
    ./git.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./networkmanager-dmenu.nix

    inputs.nix-index-database.hmModules.nix-index
  ];

  home.packages = [
    (import ./lmath.nix {inherit pkgs;})
    pkgs-unstable.zoom-us
    pkgs.feh
    pkgs.libqalculate
    pkgs.google-chrome
  ];

  # small configurations here
  programs = {
    gh.enable = true;
    firefox.enable = true;
    zathura.enable = true;
    rofi.enable = true;
    thefuck.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

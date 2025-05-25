{ pkgs, pkgs-unstable, inputs, ... }: {
  imports = [
    ./neovim
    ./alacritty.nix
    ./zsh.nix
    ./git.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./networkmanager-dmenu.nix
    ./matrix.nix

    inputs.nix-index-database.hmModules.nix-index
  ];

  home.packages = with pkgs;[
    (import ./lmath.nix {inherit pkgs;})
    pkgs-unstable.zoom-us
    feh
    libqalculate
    google-chrome
  ];

  # small configurations here
  programs = {
    gh.enable = true;
    firefox.enable = true;
    zathura.enable = true;
    rofi.enable = true;
    thefuck.enable = true;

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

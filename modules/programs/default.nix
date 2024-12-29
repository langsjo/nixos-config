{ inputs, ... }: {
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

  # small configurations here
  programs = {
    firefox.enable = true;
    zathura.enable = true;
    rofi.enable = true;

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

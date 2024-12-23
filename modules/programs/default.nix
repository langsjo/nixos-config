{ ... }: {
  imports = [
    ./neovim
    ./alacritty.nix
    ./zsh.nix
    ./git.nix
    ./oh-my-posh.nix
    ./tmux.nix
  ];

  # small configurations here
  programs = {
    firefox.enable = true;
    zathura.enable = true;

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

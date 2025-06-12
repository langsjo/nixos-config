{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./neovim
    ./alacritty.nix
    ./git.nix
    ./networkmanager-dmenu.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./zsh.nix

    inputs.nix-index-database.hmModules.nix-index
  ];

  # small configurations here
  programs = {
    firefox.enable = true;

    direnv = {
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

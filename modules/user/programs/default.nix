{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./gui
    ./neovim
    ./networkmanager-dmenu.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./zsh.nix

    inputs.nix-index-database.homeModules.nix-index
  ];

  # small configurations here
  programs = {
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

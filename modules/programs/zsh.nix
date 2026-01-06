{
  inputs,
  pkgs,
  ...
}:
{
  environment.variables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
  };

  programs = {
    zsh.enable = true;
    zoxide.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.fzf
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zsh-wrapped
  ];
}

{
  inputs,
  pkgs,
  ...
}:
let
  zsh-wrapped = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zsh-wrapped.override {
    autostartTmux = true;
  };
in
{
  environment.variables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
  };

  programs = {
    zoxide.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.fzf
    zsh-wrapped
  ];
}

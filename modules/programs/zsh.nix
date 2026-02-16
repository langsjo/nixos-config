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

{
  inputs,
  config,
  pkgs,
  ...
}:
let
  zsh-wrapped = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zsh-wrapped.override {
    autostartTmux = true;
  };
in
{
  custom.wrappers.zsh = zsh-wrapped;

  programs = {
    zoxide.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.fzf
    config.custom.wrappers.zsh
  ];
}

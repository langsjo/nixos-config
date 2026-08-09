{
  myPkgs,
  config,
  pkgs,
  ...
}:
let
  zsh-wrapped = myPkgs.zsh-wrapped.override {
    autostartTmux = false;
  };
in
{
  custom.wrappers.zsh = zsh-wrapped;

  programs = {
    zoxide.enable = true;
  };

  environment.systemPackages = [
    pkgs.fzf
    config.custom.wrappers.zsh
  ];
}

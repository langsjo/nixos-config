{
  pkgs,
  inputs,
}:
let
  wLib = inputs.wrapper-lib.lib.withSettings {
    extraArgs = { inherit inputs; };
    useBinaryWrapper = true;
  };
  mkWrapper = wLib.mkWrapper pkgs;
in
{
  alacritty-wrapped = mkWrapper ./alacritty;
  git-wrapped = mkWrapper ./git.nix;
  tmux-wrapped = mkWrapper ./tmux.nix;
  zsh-wrapped = mkWrapper ./zsh;
}

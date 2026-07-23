{
  pkgs,
  inputs,
}:
let
  wLib = inputs.wrapper-lib.lib.withSettings {
    extraArgs = {
      inherit inputs;
    }
    // wrappers;
    useBinaryWrapper = true;
  };
  mkWrapper = wLib.mkWrapper pkgs;

  wrappers = {
    alacritty-wrapped = mkWrapper ./alacritty;
    tmux-wrapped = mkWrapper ./tmux.nix;
    zsh-wrapped = mkWrapper ./zsh;
    ghostty-wrapped = mkWrapper ./ghostty.nix;
    kitty-wrapped = mkWrapper ./kitty.nix;
  };
in
wrappers

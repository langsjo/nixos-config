{
  pkgs,
  inputs,
  customPkgs,
}:
let
  wLib = inputs.wrapper-lib.lib.withSettings {
    extraArgs = {
      inherit inputs;
    }
    // wrappers
    // customPkgs;
    useBinaryWrapper = true;
  };
  mkWrapper = wLib.mkWrapper pkgs;

  wrappers = {
    alacritty-wrapped = mkWrapper ./alacritty;
    tmux-wrapped = mkWrapper ./tmux.nix;
    zsh-wrapped = mkWrapper ./zsh;
    ghostty-wrapped = mkWrapper ./ghostty.nix;
    kitty-wrapped = mkWrapper ./kitty.nix;
    niri-wrapped = mkWrapper ./niri.nix;
    niri-wrapped-nixGL = mkWrapper ./niri-nixGL.nix;
    networkmanager_dmenu-wrapped = mkWrapper ./networkmanager_dmenu.nix;
    swayidle-wrapped = mkWrapper ./swayidle.nix;
    waybar-wrapped = mkWrapper ./waybar;
  };
in
wrappers

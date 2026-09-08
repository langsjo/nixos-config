{
  config,
  pkgs,
  lib,
  inputs,
  myPkgs,
  ...
}:
let
  cfg = config.custom.programs;
  gpuType = config.custom.hardware.gpuType;
  btop' =
    if gpuType == "nvidia" then
      pkgs.btop-cuda
    else if gpuType == "amd" then
      pkgs.btop-rocm
    else
      pkgs.btop;
in
{
  imports = [
    ./gui
    ./neovim.nix
    ./zsh.nix
    ./git.nix
    ./gpg.nix
    ./yazi.nix
    ./tailscale.nix

    inputs.nix-index-database.nixosModules.nix-index
  ];

  options.custom.programs = {
    enable = lib.mkEnableOption "bunch of programs" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        gh
        wget
        unzip
        zip
        tree
        vim
        libqalculate
        dust
        file
        playerctl
        ripgrep
        hydra-check
        libsecret
        ripdrag
        attic-client
        yubikey-manager
        pv

        btop'
      ])
      ++ (with myPkgs; [
        rebuild
        tmux-wrapped
        nixpkgs-review-gha
      ]);

    hardware.acpilight.enable = config.custom.isLaptop;
    programs = {
      bat.enable = true;
      nix-index-database.comma.enable = true;
    };

    services = {
      locate = {
        enable = true;
      };
      gnome.gnome-keyring.enable = true;
    };
  };
}

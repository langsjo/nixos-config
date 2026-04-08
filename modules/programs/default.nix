{
  config,
  pkgs,
  lib,
  inputs,
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

  github-copilot-cli' = pkgs.symlinkJoin {
    inherit (pkgs.github-copilot-cli)
      pname
      version
      ;
    paths = [ pkgs.github-copilot-cli ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/copilot \
        --prefix PATH : "${lib.makeBinPath [ pkgs.bashInteractive ]}"
    '';
  };
in
{
  imports = [
    ./gui
    ./neovim.nix
    ./zsh.nix
    ./git.nix
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

        github-copilot-cli'
        btop'
      ])
      ++ (with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}; [
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

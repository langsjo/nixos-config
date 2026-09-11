{
  lib,
  inputs,
  config,
  kehvatsu,
  pkgs,
  ...
}:
let
  monitorSetUp = pkgs.writeShellScriptBin "monitors" (builtins.readFile ./monitorsetup.sh);

  nixGLexe = lib.getExe config.custom.nixGL;

  kitty-nixGL = pkgs.symlinkJoin {
    name = "kitty-nixGL";
    inherit (customPkgs.kitty-wrapped) meta;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    paths = [ customPkgs.kitty-wrapped ];
    postBuild = ''
      wrapProgram $out/bin/kitty \
        --run 'source <(grep -v "^\s*exec" "${nixGLexe}")'
    '';
  };

  customPkgs = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.nix-index-database.homeModules.default
  ];

  home.packages = with pkgs; [
    ripgrep
    zathura
    feh
    vlc
    btop
    kubectl
    rofi
    rofi-screenshot
    gh
    github-copilot-cli
    libqalculate
    dust
    wl-clipboard
    pv

    customPkgs.yubikey-add-totp
    customPkgs.neovim
    (customPkgs.zsh-wrapped.override { aalto = true; })
    customPkgs.tmux-wrapped
    customPkgs.showcerts
    customPkgs.networkmanager_dmenu-wrapped
    kitty-nixGL
    monitorSetUp
  ];

  services.dunst.enable = true;

  services.mpris-proxy.enable = true;
  services.playerctld.enable = true;
  programs.bash = {
    enable = true;
    initExtra = /* bash */ ''
      if [[ -z "$BASHRC_SOURCED" ]]; then
        export BASHRC_SOURCED=1
        exec zsh
      fi
    '';
  };

  programs.nix-index-database.comma.enable = true;

  programs.git = {
    enable = true;
    settings = builtins.head kehvatsu.config.programs.git.config;
  };

  programs.yazi = {
    enable = true;
    settings = kehvatsu.config.programs.yazi.settings.yazi;
    keymap = kehvatsu.config.programs.yazi.settings.keymap;
  };

  custom.providers = {
    editor = {
      program = "nvim";
      desktop = "nvim.desktop";
    };
    terminal = {
      program = "${nixGLexe} kitty";
      desktop = "kitty.desktop";
    };
    browser = {
      program = "firefox";
      desktop = "firefox.desktop";
    };
    fileManager = {
      program = "${nixGLexe} kitty yazi";
      desktop = "yazi.desktop";
    };
    pdfViewer = {
      program = "zathura";
      desktop = "org.pwmt.zathura.desktop";
    };
    imageViewer = {
      program = "feh";
      desktop = "feh.desktop";
    };
    videoPlayer = {
      program = "vlc";
      desktop = "vlc.desktop";
    };
  };
}

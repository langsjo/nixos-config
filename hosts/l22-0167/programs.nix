{
  inputs,
  config,
  kehvatsu,
  pkgs,
  lib,
  ...
}:
let
  networkmanager-dmenu-wrapped = inputs.wrapper-lib.lib.mkWrapper pkgs ../../modules/gui/dwm/networkmanager_dmenu-wrapped.nix;
  dwm' = kehvatsu.config.services.xserver.windowManager.dwm.package.override {
    conf = pkgs.callPackage ../../modules/gui/dwm/config/config.nix {
      inherit (config.custom) providers;
    };
  };

  monitorSetUp = pkgs.writeShellScriptBin "monitors" ''
    xrandr --output eDP-1 --off
    xrandr --output DP-2 --left-of DP-1
  '';

  kitty-nixGL-script = pkgs.writeShellScript "kitty-via-nixGL" ''
    exec nixGL kitty "$@"
  '';

  kitty-nixGL = pkgs.symlinkJoin {
    name = "kitty-nixGL";
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    paths = [ customPkgs.kitty-wrapped ];
    postBuild = ''
      rm $out/share/applications/*
      cp ${customPkgs.kitty-wrapped}/share/applications/* $out/share/applications/
      substituteInPlace $out/share/applications/* \
        --replace-fail "Exec=kitty" "Exec=${kitty-nixGL-script}"
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

    customPkgs.neovim
    customPkgs.zsh-wrapped
    customPkgs.tmux-wrapped
    kitty-nixGL
    networkmanager-dmenu-wrapped
    dwm'
    monitorSetUp
  ];

  services.dunst.enable = true;
  services.dwm-status = {
    enable = true;
    order = kehvatsu.config.services.dwm-status.settings.order;
    extraConfig = lib.mkMerge [
      (removeAttrs kehvatsu.config.services.dwm-status.settings [ "order" ])
      { backlight.device = lib.mkForce "intel_backlight"; }
    ];
  };
  systemd.user.services.dwm-status = {
    Service = {
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [[ -z "$BASHRC_SOURCED" ]]; then
        export BASHRC_SOURCED=1
        xset r rate 200 30
        setxkbmap -layout fi -variant nodeadkeys
        systemctl --user start dwm-status.service
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
      program = "nixGL kitty";
      desktop = "kitty.desktop";
    };
    browser = {
      program = "firefox";
      desktop = "firefox.desktop";
    };
    fileManager = {
      program = "nixGL kitty yazi";
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
    dwmLocker = {
      program = "i3lock";
    };
  };
}

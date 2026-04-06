{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.programs.gui;
  kitty-wrapped = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.kitty-wrapped;
  less685 = pkgs.less.overrideAttrs (old: {
    version = "685";
    src = old.src.overrideAttrs {
      hash = "sha256-JwEEHnZ+aX7kIM4IJWQc7cjyC1FXar6Z2SwWZtMy6dw=";
    };
  });
in
{
  options.custom.programs.gui.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable programs that require a GUI";
    default = config.custom.gui.enable && config.custom.programs.enable;
  };

  imports = [
    ./matrix.nix
  ];

  config = lib.mkIf cfg.enable {
    custom.wrappers.kitty = kitty-wrapped;

    environment.systemPackages = with pkgs; [
      zathura
      feh
      vlc
      lmath
      google-chrome
      ayugram-desktop
      signal-desktop

      less685 # newest less is broken with kitty
      kitty-wrapped
    ];
    programs = {
      firefox.enable = true;
      thunar.enable = true;
    };

    custom.providers = {
      terminal = {
        program = "kitty";
        desktop = "kitty.desktop";
      };
      browser = {
        program = "firefox";
        desktop = "firefox.desktop";
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

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "gui programs cannot be enabled with gui disabled";
      }
    ];
  };
}

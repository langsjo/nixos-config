{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.programs;
  kitty-wrapped = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.kitty-wrapped;
in
{
  options.custom.gui.programs.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable programs that require a GUI";
    default = config.custom.gui.enable;
    defaultText = lib.literalExpression "config.custom.gui.enable";
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

      kitty-wrapped
    ];
    programs = {
      firefox.enable = true;
      thunar.enable = true;
    };

    custom.mimetypes = {
      terminal = "kitty.desktop";
      browser = "firefox.desktop";
      fileChooser = "thunar.desktop";
      pdfViewer = "org.pwmt.zathura.desktop";
      imageViewer = "feh.desktop";
      videoPlayer = "vlc.desktop";
    };

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "gui programs cannot be enabled with gui disabled";
      }
    ];
  };
}

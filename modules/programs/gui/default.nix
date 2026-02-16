{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.programs;
  alacritty-wrapped =
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.alacritty-wrapped.override
      {
        screenDpi = config.custom.screen.dpi;
      };
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
    custom.wrappers.alacritty = alacritty-wrapped;

    environment.systemPackages = with pkgs; [
      zathura
      feh
      vlc
      lmath
      google-chrome
      ayugram-desktop
      signal-desktop

      alacritty-wrapped
    ];

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "gui programs cannot be enabled with gui disabled";
      }
    ];
  };
}

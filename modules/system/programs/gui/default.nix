{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.gui.programs;
in
{
  options.custom.gui.programs.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable programs that require a GUI";
    default = true;
  };

  imports = [
    ./matrix.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.thunar.enable = true;

    environment.systemPackages = with pkgs; [
      zathura
      rofi
      discord
      feh
      (pkgs.callPackage ./lmath.nix { })
      google-chrome
    ];

    assertions = [
      {
        assertion = !config.custom.gui.enable -> !cfg.enable;
        message = "gui programs cannot be enabled with gui disabled";
      }
    ];
  };
}

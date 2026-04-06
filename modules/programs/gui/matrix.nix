{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.custom.programs.gui.enable {
    environment.systemPackages = with pkgs; [
      element-desktop
      matrix-appservice-irc
    ];

    nixpkgs.config.element-web.conf = {
      show_labs_settings = true;
      default_theme = "dark";
    };
  };
}

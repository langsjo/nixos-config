{ pkgs, ... }: {
  home.packages = with pkgs; [
    element-desktop
    matrix-appservice-irc
  ];

  nixpkgs.config.element-web.conf = {
    show_labs_settings = true;
    default_theme = "dark";
  };

}


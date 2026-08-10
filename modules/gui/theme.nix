{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.gnome-themes-extra
  ];

  environment.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
          };
        };
      }
    ];
  };
}

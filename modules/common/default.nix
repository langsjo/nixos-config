{
  pkgs,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./nix.nix
    ./boot.nix
    ./user.nix
    ./activation-scripts.nix
    ./misc.nix
    ./options.nix
    ./envvars.nix
  ];

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];
}

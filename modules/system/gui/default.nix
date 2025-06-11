{
  pkgs,
  ...
}:
{
  imports = [
    ./ly.nix
    ./dwm.nix
  ];

  environment.systemPackages = with pkgs; [
    xorg.libXft # NOTE: This might not be needed here, try later in dwm buildInputs
  ];
}

{ ... }:
{
  imports = [
    ./input.nix
    ./networking.nix
  ];

  services = {
    locate.enable = true;
  };
}

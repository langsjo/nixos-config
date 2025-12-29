{ ... }:
{
  imports = [
    ./input.nix
  ];

  services = {
    locate.enable = true;
  };
}

{
  imports = [
    ./attic.nix
    ./dyndns.nix
  ];

  services.nginx = {
    recommendedProxySettings = true;
  };
}

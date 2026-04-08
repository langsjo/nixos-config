{
  imports = [
    ./attic.nix
    ./dyndns.nix
    ./headscale.nix
  ];

  services.nginx = {
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedBrotliSettings = true;
    recommendedUwsgiSettings = true;
  };
}

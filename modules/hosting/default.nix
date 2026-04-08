{
  imports = [
    ./attic.nix
    ./dyndns.nix
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

{
  imports = [
    ./attic.nix
    ./dyndns.nix
    ./headscale.nix
    ./resticserver.nix
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

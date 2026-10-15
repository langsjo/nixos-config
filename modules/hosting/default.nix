{
  imports = [
    ./adguardhome.nix
    ./attic.nix
    ./certs.nix
    ./dyndns.nix
    ./headscale.nix
    ./resticserver.nix
    ./qbittorrent.nix
    ./jellyfin.nix
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

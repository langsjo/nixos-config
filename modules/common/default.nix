{
  inputs,
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
    ./wrappers.nix
    ./yubikey.nix
    ./providers.nix
  ];

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];

  _module.args.myPkgs = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
}

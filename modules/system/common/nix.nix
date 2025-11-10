{ inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      trusted-users = [ "@wheel" ];
      allow-import-from-derivation = false;
      download-buffer-size = 128 * 1024 * 1024; # 128 MiB
    };

    optimise = {
      automatic = true;
      dates = [ "3:45" ];
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      unstable.flake = inputs.nixpkgs-unstable;
    };

  };

  nixpkgs.config.allowUnfree = true;
}

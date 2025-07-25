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
    };

    optimise = {
      automatic = true;
      dates = [ "3:45" ];
    };

    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  nixpkgs.config.allowUnfree = true;
}

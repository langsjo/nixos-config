{ inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      allow-import-from-derivation = false;
      download-buffer-size = 256 * 1024 * 1024; # 256 MiB
      max-substitution-jobs = 32;
      flake-registry = ""; # Disable the global flake registry
    };

    optimise = {
      automatic = true;
      dates = [ "3:45" ];
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      templates.flake = inputs.flake-templates;
    };

  };

  nixpkgs.config.allowUnfree = true;
}

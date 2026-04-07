{
  config,
  inputs,
  pkgs,
  ...
}:
let
  mkNixpkgsRegistry = name: branch: {
    from = {
      id = name;
      type = "indirect";
    };
    to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = branch;
    };
  };
in
{
  sops = {
    secrets."nix-signing-key" = { };
    secrets."github-pat" = { };
    secrets."attic-netrc-file" = { };
    templates."access-tokens" = {
      owner = config.custom.user.username;
      group = config.users.users.${config.custom.user.username}.group;
      path = "${config.custom.user.homeDirectory}/.config/nix/access-tokens.conf";
      content = ''
        access-tokens = github.com=${config.sops.placeholder."github-pat"}
      '';
    };
  };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"

        # doesn't exist on Lix
        # "pipe-operators"
      ];
      extra-substituters = [
        "https://cache.gorilla.gay/main"
      ];
      extra-trusted-public-keys = [
        "main:K95Z16k90VtpAeOr3YEqNZgVLN2eP9lfIEfPuIAKKE0="
        "langsjo:2qKa0OoaaCteNFwPeMnKtPfLMLcWAtHj11RHuxyNFws="
      ];
      netrc-file = config.sops.secrets."attic-netrc-file".path;
      secret-key-files = [ config.sops.secrets."nix-signing-key".path ];

      allowed-users = [ "@wheel" ];
      allow-import-from-derivation = false;

      # doesn't exist on Lix
      # download-buffer-size = 256 * 1024 * 1024; # 256 MiB
      max-substitution-jobs = 32;
      flake-registry = ""; # Disable the global flake registry
    };

    extraOptions = ''
      !include ${config.sops.templates."access-tokens".path}
    '';

    optimise = {
      automatic = true;
      dates = [ "3:45" ];
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      templates.flake = inputs.flake-templates;
      unstable = mkNixpkgsRegistry "unstable" "nixos-unstable";
      stable = mkNixpkgsRegistry "stable" "nixos-25.11";
      master = mkNixpkgsRegistry "master" "master";
    };
  };

  nixpkgs.config.allowUnfree = true;
}

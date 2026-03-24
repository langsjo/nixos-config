{
  config,
  inputs,
  ...
}:
{
  sops = {
    secrets."github-pat" = { };
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
    };
  };

  nixpkgs.config.allowUnfree = true;
}

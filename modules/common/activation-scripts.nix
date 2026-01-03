{
  pkgs,
  config,
  lib,
  ...
}:
{
  system.activationScripts = {
    nvd = # bash
      ''
        ${lib.getExe pkgs.nvd} --color=always --nix-bin-dir=${config.nix.package}/bin \
          diff /run/current-system "$systemConfig"
      '';
  };
}

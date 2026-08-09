{
  config,
  lib,
  myPkgs,
  ...
}:
let
  cfg = config.custom.programs;
in
{
  options.custom.programs.nvim.enable = lib.mkEnableOption "neovim" // {
    default = cfg.enable;
  };

  config = lib.mkIf cfg.nvim.enable {
    environment.systemPackages = [
      myPkgs.neovim
    ];

    environment.sessionVariables = {
      MANPAGER = "nvim +Man!";
    };

    custom.providers.editor = {
      program = "nvim";
      desktop = "nvim.desktop";
    };
  };
}

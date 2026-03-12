{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
  ];

  environment.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };

  custom.providers.editor = {
    program = "nvim";
    desktop = "nvim.desktop";
  };
}

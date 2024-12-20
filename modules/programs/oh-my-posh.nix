{ config, ... } : {

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../dotfiles/shell/zen.omp.toml);
  };
}

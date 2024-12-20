{ config, ... } : {

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../dotfiles/zen.omp.toml);
  };
}

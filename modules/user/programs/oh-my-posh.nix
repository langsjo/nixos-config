{ inputs, ... } : {

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile "${inputs.self}/dotfiles/zen.omp.toml");
  };
}

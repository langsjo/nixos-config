{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    zsh-fzf-history-search
    zsh-fzf-tab
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 20000;
      save = 20000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
    };
    historySubstringSearch.enable = true;

    sessionVariables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
    };

    shellAliases = {
      grep = "grep --color=auto";
      ls = "ls --color=auto";
      la = "ls -A --color=auto";
      ll = "ls -al --color=auto";
      ":q" = "exit";
      ":qa" = "tmux kill-session";
      c = "clear";
      n = "nvim";
      open = "xdg-open";
      tmpdir = "cd $(mktemp -d)";

      nish = "nix-shell --run zsh -p";
      nire = "nix repl -f '<nixpkgs>'";
    };

    initContent = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      eval "$(zoxide init --cmd cd zsh)"
      bindkey -e

      # Start tmux on startup
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
      fi
    '';

    completionInit = ''
       autoload -Uz compinit && compinit

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    '';
  };
}

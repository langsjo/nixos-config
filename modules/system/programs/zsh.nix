{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  environment.variables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
  };

  programs = {
    direnv.enable = true;

    zoxide = {
      enable = true;
      flags = [ "--cmd cd" ];
    };

    fzf = {
      keybindings = true;
      fuzzyCompletion = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      histSize = 20000;
      histFile = "\${XDG_DATA_HOME:-$HOME}/zsh/history";

      setOptions = [
        "HIST_IGNORE_DUPS"
        "HIST_IGNORE_SPACE"
        "SHARE_HISTORY"
        "HIST_FCNTL_LOCK"
      ];

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
        help = "run-help";

        nish = "nix-shell --run zsh -p";
        nire = "nix repl -f '<nixpkgs>'";
      };

      interactiveShellInit = ''
        eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config ${inputs.self}/dotfiles/zen.omp.toml)"

        bindkey -e

        # Start tmux on startup
        if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
          exec tmux
        fi

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

        unalias run-help
        autoload -Uz run-help
      '';
    };
  };

  wrappers.zsh = {
    env.paths.ZDOTDIR.".zshrc" = {
      source = config.environment.etc.zshrc.source;
    };
  };

}

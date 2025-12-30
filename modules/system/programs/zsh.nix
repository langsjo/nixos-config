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
      histFile = "\${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history";

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
        nibu = ''() { nix build nixpkgs#"$1" --no-link --print-out-paths; }'';
      };

      interactiveShellInit = # bash
        ''
          export XDG_CONFIG_HOME=$HOME/.config
          export XDG_DATA_HOME=$HOME/.local/share
          export XDG_STATE_HOME=$HOME/.local/state

          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
          eval "$(${lib.getExe pkgs.oh-my-posh} init zsh --config ${inputs.self}/dotfiles/zen.omp.toml)"

          bindkey -e

          # Start tmux on startup
          if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            exec tmux
          fi

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

          if alias run-help > /dev/null 2>&1 ; then
            unalias run-help
          fi
          autoload -Uz run-help

          autoload -Uz edit-command-line
          zle -N edit-command-line
          bindkey '^x^e' edit-command-line
        '';
    };
  };

  wrappers.zsh = {
    env.paths.ZDOTDIR.".zshrc" = {
      source = config.environment.etc.zshrc.source;
    };
  };

}

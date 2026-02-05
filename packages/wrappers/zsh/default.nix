{
  inputs,
  stdenv,
  coreutils,
  direnv,
  lib,
  zsh,
  zsh-fzf-tab,
  fzf,
  zsh-autosuggestions,
  zsh-syntax-highlighting,
  zoxide,
  oh-my-posh,

  autostartTmux ? false,
}:
let
  nix-index-with-db =
    inputs.nix-index-database.packages.${stdenv.hostPlatform.system}.nix-index-with-db;
in
{
  package = zsh;
  env = {
    suffixes."PATH" = lib.makeBinPath [
      fzf
      zoxide
      direnv
    ];

    paths."ZDOTDIR".".zshrc".text = # bash
      ''
        # Start tmux on startup if
        ${lib.optionalString autostartTmux ''
          if command -v tmux &> /dev/null && \
             [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && \
             [[ ! "$TERM" =~ tmux ]] && [[ -z "$TMUX" ]]; then
            exec tmux
          fi
        ''}

        setopt HIST_IGNORE_DUPS 
        setopt HIST_IGNORE_SPACE 
        setopt SHARE_HISTORY 
        setopt HIST_FCNTL_LOCK
        setopt NO_GLOBAL_RCS

        bindkey -e

        export XDG_CONFIG_HOME=$HOME/.config
        export XDG_DATA_HOME=$HOME/.local/share
        export XDG_STATE_HOME=$HOME/.local/state

        # Setup aliases.
        alias -- :q=exit
        alias -- :qa='tmux kill-session'
        alias -- c=clear
        alias -- grep='grep --color=auto'
        alias -- help=run-help
        alias -- l='ls -alh'
        alias -- la='ls -A --color=auto'
        alias -- ll='ls -al --color=auto'
        alias -- ls='ls --color=auto'
        alias -- n=nvim
        alias -- nire="nix repl -f '<nixpkgs>'"
        alias -- nish='NIXPKGS_ALLOW_UNFREE=1 nix-shell --run zsh -p'
        alias -- open=xdg-open
        alias -- tmpdir='cd $(mktemp -d)'

        function nibu() {
          package=$1
          shift
          NIXPKGS_ALLOW_UNFREE=1 nix build nixpkgs#"$package" --no-link --print-out-paths --impure "$@"
        }

        function nixpkgs-review-gha() {
          pr=$1
          shift
          gh workflow --repo langsjo/nixpkgs-review-gha run review.yml \
            -f pr="$pr" \
            "$@"
        }

        # Setup command line history.
        # Don't export these, otherwise other shells (bash) will try to use same HISTFILE.
        SAVEHIST=50000
        HISTSIZE=50000
        HISTFILE=''${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history
        mkdir -p ''${HISTFILE%/*} # Create hist directory


        source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        eval "$(${lib.getExe oh-my-posh} init zsh --config ${./zen.omp.toml})"
        eval "$(${lib.getExe zoxide} init zsh --cmd cd )"

        source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
        export ZSH_AUTOSUGGEST_STRATEGY=(history)

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

        if alias run-help > /dev/null 2>&1 ; then
        unalias run-help
        fi
        autoload -Uz run-help

        # Enable autocompletion.
        autoload -U compinit && compinit

        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^x^e' edit-command-line

        source ${nix-index-with-db}/etc/profile.d/command-not-found.sh

        source ${fzf}/share/fzf/completion.zsh
        source ${fzf}/share/fzf/key-bindings.zsh

        eval "$(${lib.getExe direnv} hook zsh)"

        source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

        # Extra colors for directory listings.
        eval "$(${lib.getExe' coreutils "dircolors"} -b)"

        autoload -U promptinit && promptinit && prompt suse && setopt prompt_sp

        # Disable some features to support TRAMP.
        if [ "$TERM" = dumb ]; then
          unsetopt zle prompt_cr prompt_subst
          unset RPS1 RPROMPT
          PS1='$ '
          PROMPT='$ '
        fi
      '';
  };
}

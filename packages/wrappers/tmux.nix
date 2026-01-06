{
  lib,
  tmux,
  tmuxPlugins,
  fetchFromGitHub,
}:
let
  plugins = [
    tmuxPlugins.sensible
    tmuxPlugins.vim-tmux-navigator
    tmuxPlugins.yank
    (tmuxPlugins.catppuccin.overrideAttrs {
      src = fetchFromGitHub {
        owner = "dreamsofcode-io";
        repo = "catppuccin-tmux";
        rev = "b4e0715356f820fc72ea8e8baf34f0f60e891718";
        hash = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
      };
    })
  ];
in
{
  package = tmux;
  flags.path."-f"."/".text = /* tmux */ ''
    set  -g default-terminal "xterm-256color"
    set  -g base-index      1
    setw -g pane-base-index 1
    set  -g history-limit   50000

    set -g status-keys vi
    set -g mode-keys   vi

    # rebind main key: C-Space
    unbind C-b
    set -g prefix C-Space
    bind Space send-prefix
    bind C-Space last-window


    setw -g aggressive-resize off
    setw -g clock-mode-style  24
    set  -s escape-time       500

    # Run plugins
    ${lib.concatMapStringsSep "\n" (plugin: "run-shell ${plugin.rtp}") plugins}

    # The color setting on this line needs to be the same as in alacritty/whatever terminal is used
    set -ag terminal-overrides ",xterm-256color:Tc"

    bind -n M-C-h previous-window
    bind -n M-C-l next-window
    bind -n M-C-j swap-window -t -1\; select-window -t -1
    bind -n M-C-k swap-window -t +1\; select-window -t +1
    bind -T copy-mode-vi v send-keys -X begin-selection
    bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

    # Open new panes/windows in CWD
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"
  '';
}

{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "b";
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      (catppuccin.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          "owner" = "dreamsofcode-io";
          "repo" = "catppuccin-tmux";
          "rev" = "b4e0715356f820fc72ea8e8baf34f0f60e891718";
          "hash" = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
        };
      }))
      yank
    ];

    extraConfig = ''
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


        # is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        #   grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|\.?n?vim?x?(-wrapped)?)(diff)?$'"
    '';
  };
}

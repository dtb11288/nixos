{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 1000000;
    keyMode = "vi";
    newSession = true;
    mouse = true;
    escapeTime = 0;

    extraConfig = ''
      unbind C-b
      set -g prefix M-a
      set -g detach-on-destroy off
      set -g renumber-windows on
      set -g set-clipboard on

      # switch windows alt+number
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9

      # new window
      bind-key -n M-c new-window

      # move around panes
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-l select-pane -R

      # split window
      bind-key -n M-\\ split-window -h
      bind-key -n M-\- split-window -v

      # session select
      bind-key -n M-f display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

      # status bar
      set -g status-position bottom
      set -g status-style bg=colour234,fg=colour137,dim
      set -g status-left '''
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20

      setw -g window-status-current-style fg=colour81,bg=colour238,bold
      setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
      setw -g window-status-style fg=colour138,bg=colour235,none
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      setw -g window-status-bell-style fg=colour255,bg=colour1,bold
    '';

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
  };
}

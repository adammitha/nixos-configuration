{ config, pkgs, ...}:
{
  programs.tmux = {
    baseIndex = 1;
    enable = true;
    escapeTime = 0;
    extraConfig = builtins.readFile .config/tmux/tmux.conf;
    historyLimit = 100000;
    mouse = true;
    terminal = "xterm-256color";
  };
}

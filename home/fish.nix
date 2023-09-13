{ config, pkgs, ...}:
{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };
}


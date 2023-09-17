{ config, pkgs, ...}:
{
  imports = [
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
  ];

  home = {
    username = "adam";
    homeDirectory = "/home/adam";
    stateVersion = "23.05";
  };
}

{ config, pkgs, ...}:
{
  imports = [
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./git.nix
    ./neovim
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
  ];

  home = {
    username = "adam";
    homeDirectory = "/home/adam";
    sessionVariables = {
      FZF_DEFAULT_COMMAND = "fd --type f";
    };
    stateVersion = "23.05";
  };
}

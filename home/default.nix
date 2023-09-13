{ config, pkgs, ...}:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./starship.nix
  ];
}

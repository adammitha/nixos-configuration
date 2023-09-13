{ config, pkgs, ...}:

let
  username = "adam";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./starship.nix
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "23.05";
  };

  xdg = {
    inherit configHome;
    enable = true;
    configFile = {
      gruvbox = {
        source = .config/fish/themes/gruvbox.theme;
	target = "fish/themes/gruvbox.theme";
      };
      allowed_signers = {
        source = .config/git/allowed_signers;
	target = "git/allowed_signers";
      };
    };
  };

  programs = {
    tmux = {
      baseIndex = 1;
      enable = true;
      escapeTime = 0;
      extraConfig = builtins.readFile .config/tmux/tmux.conf;
      historyLimit = 100000;
      mouse = true;
      terminal = "xterm-256color";
    };
  };
}

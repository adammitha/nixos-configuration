{ config, pkgs, ... }:

let
  username = "adam";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "23.05";
  };

  xdg = {
    inherit configHome;
    enable = true;
    configFile = {
      gruvbox = {
        source = ./gruvbox.theme;
	target = "fish/themes/gruvbox.theme";
      };
      allowed_signers = {
        source = ./allowed_signers;
	target = "git/allowed_signers";
      };
    };
  };

  programs = {
    fish = {
      enable = true;
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
    };
    git = {
      enable = true;
      userName = "Adam Mitha";
      userEmail = "adam.mitha@gmail.com";
      extraConfig = {
        commit.gpgsign = true;
        gpg = {
	  format = "ssh";
	  ssh = {
	    allowedSignersFile = "/home/adam/.config/git/allowed_signers";
	  };
	};
        init.defaultBranch = "main";
	pull.rebase = true;
	user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAB/AenixWNi2t7mPamUlXvq7jcVH3PaLHXo6OAYpc8d adam.mitha@gmail.com";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        hostname = {
        	ssh_symbol = " 🌐";
          format = "[$hostname$ssh_symbol]($style)in ";
        };
	nix_shell = {
	  heuristic = true;
	};
        username = {
          format = "[$user]($style) @ ";
        };
      };
    };
    tmux = {
      baseIndex = 1;
      enable = true;
      escapeTime = 0;
      extraConfig = ''
      # COLOUR (base16)
      # default statusbar colors
      set-option -g status-style "fg=#bdae93,bg=#3c3836"

      # default window title colors
      set-window-option -g window-status-style "fg=#bdae93,bg=default"

      # active window title colors
      set-window-option -g window-status-current-style "fg=#fabd2f,bg=default"

      # pane border
      set-option -g pane-border-style "fg=#3c3836"
      set-option -g pane-active-border-style "fg=#504945"

      # message text
      set-option -g message-style "fg=#d5c4a1,bg=#3c3836"

      # pane number display
      set-option -g display-panes-active-colour "#b8bb26"
      set-option -g display-panes-colour "#fabd2f"

      # clock
      set-window-option -g clock-mode-colour "#b8bb26"

      # copy mode highligh
      set-window-option -g mode-style "fg=#bdae93,bg=#504945"

      # bell
      set-window-option -g window-status-bell-style "fg=#3c3836,bg=#fb4934"

      # Fix titlebar
      set -g set-titles on
      set -g set-titles-string "#T"
      '';
      historyLimit = 100000;
      keyMode = "vi";
      mouse = true;
      terminal = "xterm-256color";
    };
  };
}


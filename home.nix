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
      "git/allowed_signers".text = ''
      # Keys permitted to sign git commits
      adam.mitha@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAB/AenixWNi2t7mPamUlXvq7jcVH3PaLHXo6OAYpc8d adam.mitha@gmail.com
      '';
    };
  };

  programs = {
    fish = {
      enable = true;
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        username = {
          format = "[$user]($style) @ ";
        };
        hostname = {
        	ssh_symbol = " 🌐";
          format = "[$hostname$ssh_symbol]($style)in ";
        };
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
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
  };
}


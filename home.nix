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
      coc = {
        enable = true;
      };
      defaultEditor = true;
      enable = true;
      extraPackages = [ pkgs.fzf ];
      plugins = with pkgs.vimPlugins; [
        {
          plugin = fzf-vim;
          config = "nnoremap <C-p> :Files<CR>";
        }
        {
          plugin = vim-oscyank;
          config = "autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister \"' | endif";
        }
        {
          plugin = base16-vim;
          config =
          ''
          if !has('gui_running')
            set t_Co=256
          endif
          set background=dark
          let base16colorspace=256
          autocmd vimenter * ++nested colorscheme base16-gruvbox-dark-soft
          hi Normal ctermbg=NONE
          '';
        }
        {
          plugin = nerdtree;
        }
        {
          plugin = lualine-nvim;
          type = "lua";
          config =
          ''
          require('lualine').setup {
            options = { theme = 'gruvbox' }
          }
          '';
        }
      ];
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
      extraConfig = builtins.readFile .config/tmux/tmux.conf;
      historyLimit = 100000;
      mouse = true;
      terminal = "xterm-256color";
    };
  };
}


{ config, pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    nerdtree
    vim-sleuth
    {
      plugin = base16-vim;
      config =
        ''
          if !has('gui_running')
            set t_Co=256
          endif
          if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
            " screen does not (yet) support truecolor
            set termguicolors
          endif
          set background=dark
          let base16colorspace=256
          autocmd vimenter * ++nested colorscheme base16-gruvbox-dark-soft
          hi Normal ctermbg=NONE
        '';
    }
    {
      plugin = fzf-vim;
      config = "nnoremap <C-p> :Files<CR>";
    }
    {
      plugin = lualine-nvim;
      type = "lua";
      config =
        ''
          require('lualine').setup {
            options = { theme = 'gruvbox' },
            sections = {
              lualine_c = {
                {
                  'filename',
                  path = 1
                }
              }
            }
          }
        '';
    }
    {
      plugin = vim-oscyank;
      config = "autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister \"' | endif";
    }
  ];
}

{ config, pkgs, ...}:
{
  programs.neovim = {
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
}

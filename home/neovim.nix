{ config, pkgs, ...}:
{
  programs.neovim = {
    coc = {
      enable = true;
      pluginConfig =
      ''
      set tagfunc=CocTagFunc

      " Coc shortcuts
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)
      nmap <silent> rn <Plug>(coc-rename)
      nmap <silent> <C-h> :CocCommand clangd.switchSourceHeader<CR>
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
      nmap <leader>ac <Plug>(coc-codeaction)
      nmap <C-f> :CocCommand editor.action.formatDocument<CR>

      let g:coc_filetype_map = {
            \ 'tf': 'terraform'
            \ }

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Use K to show documentation in preview window.
      nnoremap <silent> <leader>K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction
      '';
    };
    defaultEditor = true;
    enable = true;
    extraConfig =
    ''
    set number
    set mouse=a
    set nohlsearch
    set shiftwidth=4
    set tabstop=4
    set autoindent
    set smartindent
    set smartcase
    set ff=unix

    " Tab shortcuts
    nnoremap <C-j> :tabprevious<CR>
    nnoremap <C-k> :tabnext<CR>
    '';
    extraPackages = [ pkgs.fzf ];
    plugins = with pkgs.vimPlugins; [
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
        plugin = nerdtree;
      }
      {
        plugin = vim-oscyank;
        config = "autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister \"' | endif";
      }
      {
        plugin = vim-sleuth;
      }
    ];
  };
}

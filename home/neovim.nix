{ config, pkgs, ...}:
{
  programs.neovim = {
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
      nerdtree
      nvim-lspconfig
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
        plugin = rust-tools-nvim;
        type = "lua";
        config =
        ''
        local rt = require("rust-tools")

        rt.setup({
          server = {
            on_attach = function(_, bufnr)
              -- Hover actions
              vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
              -- Code action groups
              vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
          },
        })
        rt.inlay_hints.enable()
        '';
      }
      {
        plugin = vim-oscyank;
        config = "autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister \"' | endif";
      }
    ];
  };
}

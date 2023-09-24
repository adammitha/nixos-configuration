{ config, pkgs, ... }:
{
  imports = [
    ./plugins.nix
  ];
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
  };
}

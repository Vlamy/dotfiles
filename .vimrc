let mapleader = ","

set bs=2
set tw=0
set cindent
set mouse=a
set mousehide
set nowrapscan
set showmatch
set showmode
set uc=0
map \e[3~ x
let c_comment_strings=1
 
syntax on
 
"Vundle
set nocompatible "required for vundle
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle 'VundleVim/Vundle.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'scrooloose/nerdtree'
Bundle 'epmatsw/ag.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/bufkill.vim'

call vundle#end()            " required
filetype plugin indent on    " required

colorscheme delek
set guifont=Monospace\ 8
set foldmethod=indent
set nu
 
" indent with two spaces (= Mozilla guidelines)
set tabstop=2
set shiftwidth=2
set expandtab
 
" search
set hlsearch
set ignorecase
set smartcase
set incsearch
 
" disable incrementation of octal numbers
set nrformats=hex
 
" use the current file's directory as Vim's working directory
set autochdir
 
" ________________________________________________________
"
" custom mappings
" ________________________________________________________
" remap the escape key (too far)
imap jj <Esc>

map <leader>n :NERDTreeToggle<cr>


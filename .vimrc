let mapleader = "f"

set bs=2
set tw=0
set mouse=a
set mousehide
set nowrapscan
set showmatch
set showmode
set uc=0

set shell=/bin/sh "macvim rvm integration
set clipboard=unnamed "use Os X clipboard

syntax enable

"tralling whitespace on save
autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e

"Vundle
set nocompatible "required for vundle
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle 'VundleVim/Vundle.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'scrooloose/nerdtree'
Bundle 'epmatsw/ag.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/bufkill.vim'
"Bundle 'szw/vim-tags'
Bundle 'scrooloose/nerdcommenter'
Bundle 'jonathanfilip/vim-lucius'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'flazz/vim-colorschemes'
Bundle 'pangloss/vim-javascript'
Bundle 'elixir-lang/vim-elixir'
Bundle 'mattn/emmet-vim'
Bundle 'tpope/vim-endwise'
Bundle 'Raimondi/delimitMate'
"Bundle 'jelera/vim-javascript-syntax'

call vundle#end()            " required
filetype plugin indent on    " required

"set background=dark
colorscheme zazen

"Cursor highlight
au WinLeave * setlocal nocursorline nocursorcolumn
au WinEnter * setlocal cursorline cursorcolumn
"augroup CursorLine
"au!
"  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au WinLeave * setlocal nocursorline
"augroup END
set cursorline cursorcolumn
highlight CursorColumn ctermbg=235
highlight CursorLine cterm=NONE ctermbg=235

set nu

let NERDTreeQuitOnOpen = 1

" indent with two spaces (= Mozilla guidelines)
set tabstop=4
set shiftwidth=4
set expandtab

" Js specific indent
"autocmd FileType js setlocal shiftwidth=4 tabstop=4

"search
set hlsearch
set ignorecase
set smartcase
set incsearch

"inentation
set smartindent
set autoindent

" disable incrementation of octal numbers
set nrformats=hex

" highlight 80th column
set colorcolumn=80
highlight ColorColumn ctermbg=235

" list of invisble chars to display
set listchars=nbsp:¬,trail:•
set list! "You see these breakpaces ?

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" ________________________________________________________
"
" custom mappings
" ________________________________________________________
" remap the escape key (too far)
imap <C-i> <Esc>

" remap the command key
nmap <C-i> :

"list buffer and preselect buffer command
map <leader>b :ls<cr>:buffer<Space>
map <leader>n :NERDTreeToggle<cr>
map <leader>s :Ag<Space>

"ruby map in ..vim/after/ftplugin/ruby.vim
":map [[ ?def <CR>
":map ]] /def <CR>

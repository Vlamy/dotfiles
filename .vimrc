" source the .vimrc file on save to apply all changes immediately
"if has("autocmd")
"  autocmd! bufwritepost .vimrc source ~/.vimrc
"endif 

execute pathogen#infect()
 
" ________________________________________________________
"
"     Zenwalk's default settings
" ________________________________________________________
 
set nocompatible
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
 
" Color for xiterm, rxvt, nxterm, color-xterm:
if has("terminfo")
	set t_Co=8
	set t_Sf=\e[3%p1%dm
	set t_Sb=\e[4%p1%dm
else
	set t_Co=8
	set t_Sf=\e[3%dm
	set t_Sb=\e[4%dm
endif
 
syntax on
filetype plugin on
filetype plugin indent on
 
" ________________________________________________________
"
"     Personal settings
" ________________________________________________________
 
colorscheme delek
set guifont=Monospace\ 8
set foldmethod=indent
set nu
 
" highlight nbsp ( )
highlight NbSp ctermbg=lightgrey guibg=lightred
match NbSp /\%xa0/
 
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
"     Personal mappings
" ________________________________________________________
 
"
"-------------------------
" Ecim setting
"-------------------------
set guioptions-=m " turn off menu bar
set guioptions-=T " turn off toolbar
set guioptions-=L " turn off left scrollbar

nmap <silent> <c-SPACE> :call eclim#vimplugin#FeedKeys('Ctrl+Space')<cr>
nmap <silent> <c-f> :call eclim#vimplugin#FeedKeys('Ctrl+f')<cr>

" BÉPO key bindings
source ~/.vimrc.bepo

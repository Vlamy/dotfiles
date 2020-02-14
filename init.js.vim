" indent with four spaces
set tabstop=4
set shiftwidth=4
set expandtab

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'neomake/neomake', { 'commit': 'd5529f87ef3f9dee9ee534b43f128f164cabb900' }
Plug 'flazz/vim-colorschemes'
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'claco/jasmine.vim', { 'for': 'javascript' }
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-endwise'
Plug '907th/vim-auto-save'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-endwise'
Plug 'vim-scripts/bufkill.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'Raimondi/delimitMate'
Plug 'brooth/far.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'kien/ctrlp.vim'
Plug 'machakann/vim-highlightedyank'
call plug#end()

" ________________________________________________________
" Plugin config
" ________________________________________________________
"
" neomake
let g:neomake_javascript_enabled_makers = ['eslint']

let g:used_javascript_libs = 'angularjs,angularui,angularuirouter,react,jasmine'
let g:jsx_ext_required = 0 "allows jsx for js files

" Use deoplete.
let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = '0'  " This do disable full signature type on autocomplete
"
"Add extra filetypes
let g:tern#filetypes = ['jsx', 'javascript.jsx' ]

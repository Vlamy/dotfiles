" OSX specific
set clipboard=unnamed "use Os X clipboard

" list of invisble chars to display
set listchars=nbsp:¬,trail:•,tab:>-
set list! "You see these breakpaces ?

set nu

" indent with four spaces
set tabstop=4
set shiftwidth=4
set expandtab

"
" Make sure you use single quotes
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'neomake/neomake', { 'commit': 'd5529f87ef3f9dee9ee534b43f128f164cabb900' }
Plug 'flazz/vim-colorschemes'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'elixir-lang/vim-elixir'
Plug 'thinca/vim-ref'
Plug 'awetzel/elixir.nvim', { 'do': 'yes \| ./install.sh' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'claco/jasmine.vim', { 'for': 'javascript' }
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-endwise'
Plug '907th/vim-auto-save'
Plug 'epmatsw/ag.vim'
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
Plug 'lumiliet/vim-twig'
Plug 'kien/ctrlp.vim'
Plug 'machakann/vim-highlightedyank'
call plug#end()

" colors
set t_Co=256
set background=dark
colorscheme northland

" highlight 80th column
set colorcolumn=80
highlight ColorColumn ctermbg=235

" native completion config
set completeopt-=preview
set completeopt=longest,menuone

" custom JS folding
autocmd FileType javascript,typescript,json setlocal foldmarker={,}
set foldmethod=marker

" ________________________________________________________
" Plugin config
" ________________________________________________________
"
" neomake
let g:neomake_javascript_enabled_makers = ['eslint']
autocmd! BufWritePost,BufEnter * Neomake
"
" Use deoplete.
let g:deoplete#enable_at_startup = 1

let NERDTreeQuitOnOpen = 1
let NERDTreeHijackNetrw=1

let g:used_javascript_libs = 'angularjs,angularui,angularuirouter,react,jasmine'

let g:jsx_ext_required = 0 "allows jsx for js files

" Use deoplete.
let g:tern_request_timeout = 1
let g:tern_show_signature_in_pum = '0'  " This do disable full signature type on autocomplete

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

"Add extra filetypes
let g:tern#filetypes = ['jsx', 'javascript.jsx' ]

let g:auto_save = 1
let updatetime=1000
let g:auto_save_events = ["CursorHold", "CursorHoldI", "WinEnter", "WinLeave"]

let g:far#source = 'ag'

" status bar customization
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='monochrome'
" ________________________________________________________
"
" custom mappings
" ________________________________________________________
let mapleader = "f"

map <leader>n :NERDTreeToggle<cr>

map <leader>b :ls<cr>:buffer<Space>

" remap the command
imap <C-d> <Esc>:w<CR>:

"try to have a different behavior with readonly files
nmap <C-d> :
nmap <C-c> :w<CR>

"append semi-colon
imap ,, <end>;<Esc>
nmap ,, A;<Esc>

" Save on escape
inoremap <C-c> <Esc>:w<CR>
inoremap <Esc> <Esc>:w<CR>

" completeopt remapping
noremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

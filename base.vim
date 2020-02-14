" list of invisble chars to display
set listchars=nbsp:¬,trail:•,tab:\ \•
set list! "You see these breakpaces ?

set nu

" indent with four spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Instal Plug --
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Make sure you use single quotes
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'neomake/neomake', { 'commit': 'd5529f87ef3f9dee9ee534b43f128f164cabb900' }
Plug 'flazz/vim-colorschemes'
"Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'elixir-lang/vim-elixir'
Plug 'thinca/vim-ref'
Plug 'awetzel/elixir.nvim', { 'do': 'yes \| ./install.sh' }
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
Plug 'lifepillar/vim-solarized8'
Plug 'fatih/vim-go'
call plug#end()

" colors
set t_Co=256
set background=dark
set termguicolors
colorscheme solarized8_dark_low

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
autocmd! BufWritePost,BufEnter * Neomake
"
" Use deoplete.
let g:deoplete#enable_at_startup = 1

let NERDTreeQuitOnOpen = 1
let NERDTreeHijackNetrw=1

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

let g:auto_save = 1
let updatetime=1000
let g:auto_save_events = ["CursorHold", "CursorHoldI", "WinEnter", "WinLeave"]

let g:far#source = 'ag'

" status bar customization
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='monochrome'

" go config
let g:go_metalinter_command= 'golangci-lint'
let g:go_metalinter_autosave= 1
let g:go_highlight_diagnostic_warnings= 0
let g:syntastic_go_checkers= ['gometalinter']
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

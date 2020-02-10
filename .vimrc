syntax enable

set autoread

" ---------------------------------------------------------
" Appearance
" ---------------------------------------------------------
set number
set showcmd
set cursorline
set showmatch
set laststatus=2
set title

" ---------------------------------------------------------
" Tab
" ---------------------------------------------------------
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" ---------------------------------------------------------
" Search
" ---------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

" ---------------------------------------------------------
" Keymap
" ---------------------------------------------------------
inoremap <silent> jj <ESC>
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>


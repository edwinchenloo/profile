call plug#begin()
Plug 'http://github.com/gauteh/vim-cppman'                                    " sudo apt-get install cppman
Plug 'http://github.com/cappyzawa/trim.nvim'                                  " strip whitespace at end of lines
"Plug 'http://github.com/nvim-treesitter/nvim-treesitter'
Plug 'http://github.com/yegappan/mru'                                         " Most recently used files
"Plug 'http://github.com/p00f/nvim-ts-rainbow'                                 " Nested parenthesis coloring
Plug 'http://github.com/frazrepo/vim-rainbow'                                 " Nested parenthesis coloring
let g:rainbow_active = 1

"Plug 'http://github.com/lukas-reineke/indent-blankline.nvim'
Plug 'http://github.com/Yggdroot/indentLine'
" indentLine
let g:indentLine_char = '▏'
let g:indentLine_defaultGroup = 'NonText'
" Disable indentLine from concealing json and markdown syntax (e.g. ```)
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

"Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Main configuration
filetype plugin indent on
set autoread
set clipboard+=unnamedplus      " Map Neovim yank's buffer to your clipboard buffer
set noshowmode                  " Show current mode
set incsearch                   " Shows the match while typing
set hidden                      " Allow switching to new buffers without saving
set hlsearch                    " Highlight found searches
set ignorecase                  " Search case insensitive...
set lcs=trail:~,nbsp:␣,trail:·,extends:◣,precedes:◢,nbsp:○,tab:▶.
set list
set number
set path+=**                    " Allow 'gf' to go to file under cursor
set ruler laststatus=2 showcmd showmode
set smartcase                   " ... but not when search pattern contains upper case characters
set autoindent
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab smarttab
set termguicolors

" Show â†ª at the beginning of wrapped lines
if has("linebreak")
    let &sbr = nr2char(8618).' '
endif

" use ripgrep for grep
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat=%f:%l:%c:%m

" Save on focus lost
augroup save_on_focus_lost
    autocmd!
    autocmd BufWritePre,FocusLost * silent! wall
augroup EN

autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None  " Notification of file changed on disk
"autocmd FileType c,cpp,cs,h,hpp,lisp,py,ruby,rust RainbowParentheses                                            " Enable colored nasted parenthesis
autocmd BufWritePost $MYVIMRC source $MYVIMRC                                                                   " Reload init.vim file after it is saved

nnoremap <Tab>     :bnext<CR>
nnoremap <S-Tab>   :bprevious<CR>
nnoremap <C-J>     :bprevious<CR>                                                                               " Previous buffer
nnoremap <C-K>     :bnext<CR>                                                                                   " Next buffer
nnoremap <Leader>i :e $MYVIMRC<cr>
nnoremap <leader>t <C-w>s<C-w>j:terminal<CR>:set nonumber<CR><S-a>
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l


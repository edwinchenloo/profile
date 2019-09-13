"if has("multi_byte")
"  if &termencoding == ""
"     let &termencoding = &encoding
"  endif
"  set encoding=utf-8
"  setglobal fileencoding=utf-8
"  "setglobal bomb
"  set fileencodings=ucs-bom,utf-8,latin1
"endif


filetype on                   " Enable filetype detection
filetype indent on            " Enable filetype-specific indenting
filetype plugin on            " Enable filetype-specific plugins
"set background=dark
"set ruler                     " show the line number on hte bar


highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE 
highlight MatchParen cterm=bold ctermbg=green ctermfg=black guifg=green guibg=black

set autoread                   " watch for file changes
set backspace=indent,eol,start " got backspace?
"set backup
"set backupdir=$HOME/.vim_backup
set complete=.,w,b,u,U,t,i,d   " do lots of scanning on tab completion
set completeopt=longest,menuone,preview
set diffopt=filler,iwhite      " ignore all whitespace and sync
set expandtab                  " expand <tab>s to spaces
set fileformats=unix
set formatoptions-=cro
set history=500
set hlsearch                  " highlight searched
set incsearch                 " start searching while typing search string chars
set ignorecase                " when doing searches
set laststatus=2
"set list                      " show invisible characters
"set listchars=trail:·,extends:>,nbsp:·,tab:»\ ,precedes:<
set matchtime=5               " blink matching chars for this number of seconds
set mouse=r                   " enble mouse support in console
set noerrorbells
set nohidden                  " remove the buffer after closing it
set nostartofline             " leave my cursor position alone
set number                    " line Numbers on gutter
set report=0                  " report back number of lines yanked or deleted
set scrolloff=5               " keep at least 5 lines above/below
set shiftwidth=4              " spaces for each step
"set showbreak='¬'             " for wrapped lines
set showcmd
set showmatch                 " show matching bracket
set smartcase                 " if pattern includes upper and lower case it is case sensitive, otherwise it is not
set smarttab                  " tab and backspace are smart
set softtabstop=4             " set virtual tab stop
set t_Co=256
set t_vb=                     " visual bell
set tabstop=4
set ttyfast                   " we have a fast terminal
set undolevels=1000
set updatecount=100           " switch every 100 chars
set visualbell
set wildmenu                  " menu has tab completion
set wildmode=list:longest,full " set wildmenu to list choice
set wrap                      " soft wrap long lines

"Number of line of output window (e.g. when invoking make)
let g:asyncrun_open = 20

"function! Browser ()
"   let line = getline (".")
"   let line = matchstr (line, "http[^   ]*")
"   exec "!chrome ".line
"endfunction

" Switch between header and cpp file using Alt-o
"execute "set <M-o>=o"
"nnoremap <silent> <M-o> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" Invoke make
"nnoremap <silent> <F6> :call Uncrustify('cpp')<CR>

" Invoke make
"nnoremap <silent> <F7> :wa\|make -j8 install\|copen<CR>
"nnoremap <silent> <F7> :wa\|AsyncRun -raw -cwd=$(VIM_FILEDIR) /opt/anaconda-python-2.7.8/bin/python -m xrmake -j 23 -d <cr>
"nnoremap <silent> <F7> :wa\|AsyncRun -raw python -m xrmake -j 23 -d <cr>
nnoremap <silent> <F7> :wa\|AsyncRun g++ -std=c++14 "%"<cr>

" dos2unix
nnoremap <silent> <F9> :%s/$//g<CR>:%s// /g<CR>

" Write as sudo
cmap w!! w !sudo tee '%' > /dev/null

"type :PlugUpdate to update them
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic', { 'for' : [ 'cpp', 'c', 'h', 'hpp' ] }
Plug 'lyuts/vim-rtags'
Plug 'skywind3000/asyncrun.vim'

call plug#end()



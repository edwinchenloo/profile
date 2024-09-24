"if has("autocmd")
   filetype indent on            " Enable filetype-specific indenting
   filetype plugin on            " Enable filetype-specific plugins

   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

   " Makefiles require tab characters
   au FileType make set tabstop=4 shiftwidth=4 softtabstop=0 expandtab
"endif

filetype on                   " Enable filetype detection
filetype indent on            " Enable filetype-specific indenting
filetype plugin indent on     " Enable filetype-specific plugins
"set background=dark
"set ruler                     " show the line number on the bar

fu! SaveSess()
    execute 'mks! ' . getcwd() . '/.session.vim'
endfunction

fu! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
endfunction

" Save file after editing
autocmd InsertLeave * write
autocmd BufWritePre * %s/\s\+$//e
"autocmd VimLeave * call SaveSess()
"autocmd VimEnter * nested call RestoreSess()

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight MatchParen cterm=bold ctermbg=green ctermfg=black guifg=green guibg=black
highlight Search guibg='Purple' guifg='NONE'

let mapleader = " "
set autoindent
set autoread                   " watch for file changes
set backspace=indent,eol,start " got backspace?
"set backup
"set backupdir=$HOME/.vim_backup
set clipboard=unnamedplus
"set complete=.,w,b,u,U,t,i,d   " do lots of scanning on tab completion
"set completeopt=longest,menuone,preview
set diffopt=filler,iwhite      " ignore all whitespace and sync
set encoding=utf-8
"set errorformat=%f:%l:%c:%m
set expandtab                  " expand <tab>s to spaces
set encoding=utf-8
scriptencoding utf-8
set fileformats=unix
set formatoptions-=acro
set hidden                    " allow switching buffers without saving it
set history=500
set hlsearch                  " highlight searched
set incsearch                 " start searching while typing search string chars
set ignorecase                " when doing searches
set laststatus=2
"set list                      " show invisible characters
set list lcs=tab:»·
set list lcs+=nbsp:␣
set list lcs+=trail:·
set list lcs+=precedes:«
set list lcs+=extends:»
set matchtime=5               " blink matching chars for this number of seconds
set noerrorbells
set nostartofline             " leave my cursor position alone
set number                    " line Numbers on gutter
"set paste noai                " don't autoindent while pasting from clipboard
set path=.,**
set path+=/usr/include/**
"set path+=/lhome/snap/ext/**
set path+=$SNAP_ROOT_DIR/ext/monorepo/dist/relwithdebinfo/include/**
set path+=$SNAP_ROOT_DIR/xr-snap/src/xr/snap/**
set path+=$SNAP_ROOT_DIR/ext/**
set path+=$TRADER_REPO_DIR/**
set path+=$XR_MONOREPO_ROOT/cpp/libs/**
set path+=$XR_MONOREPO_ROOT/**
set report=0                  " report back number of lines yanked or deleted
set scrolloff=5               " keep at least 5 lines above/below
set shiftwidth=4              " spaces for each step
"set showbreak='¬'             " for wrapped lines
set showcmd
set showmatch                 " show matching bracket
set smartcase                 " if pattern includes upper and lower case it is case sensitive, otherwise it is not
set smartindent
set smarttab                  " tab and backspace are smart
set softtabstop=4             " set virtual tab stop
set statusline+=%F
set t_BE=                     " disable bracketed paste mode
set t_Co=256
set t_vb=                     " visual bell
set tabstop=4
set termguicolors
set ttyfast                   " we have a fast terminal
set undolevels=1000
set updatecount=100           " switch every 100 chars
set visualbell
set wildignore=*.dll,*.exe,*.so,*.a    " ignore these when searching over wildcard files
set wildmenu                  " menu has tab completion
set wildmode=list:longest,full " set wildmenu to list choice
set wrap                      " soft wrap long lines

" terminal colors
"highlight Normal guibg=black guifg=white
syntax on
hi Normal ctermbg=black ctermfg=white


if has('mouse')
  set mouse=r                   " enble mouse support in console
endif


"function! Browser ()
"   let line = getline (".")
"   let line = matchstr (line, "http[^   ]*")
"   exec "!chrome ".line
"endfunction

" Switch between header and cpp file using Ctrl-o
"execute "set <M-o>=o"
nnoremap <silent> <c-o> :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>
"nnoremap <silent> <c-O> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" Switch buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <S-m> :MRU<CR>

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>t <cmd>:term<cr>

" Invoke make
"nnoremap <silent> <F6> :call Uncrustify('cpp')<CR>

"let PYTHONNUNBUFFERRED=1
"let g:asyncrun_encs = 'utf-8'

nnoremap <silent> <F3> :/error:<CR>
nnoremap <silent> <F4> :execute "vimgrep /" . expand("<cword>") . "/j **/*"<Bar>cw<CR>

nnoremap q <c-v>

" Invoke make
nnoremap <silent> <F5> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 make -j 8 <cr>
"nnoremap <silent> <F5> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 -cwd=~/TastyWorksPnL/build make -j 3 <cr>
"nnoremap m :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 -cwd=~/TastyWorksPnL/build make -j 3 <cr>
"-nnoremap <silent> <F5> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 -cwd=/lhome/dd.ModelResponses/build make -j 8 <cr>

"nnoremap <silent> <F6> :AsyncRun -raw -save=2 -pos=bottom -mode=0 python -m xrmake2 -j 8 --fast-build --enable-debug --enable-onload201811_U1 <cr>
"nnoremap <silent> <F6> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 python -m maketraderunit --rocket -j 2 -d -v <cr>
nnoremap <silent> <F6> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 ~/bin/buildt.sh <cr>

nnoremap <silent> <F7> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 ~/bin/builds.sh <cr>

"Nnoremap <silent> <F8> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 -post=AnsiEsc python -u -m xrbuild -rv release <cr>
nnoremap <silent> <F8> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 ~/bin/buildm.sh <cr>
"nnoremap <silent> <F8> :AsyncRun -raw=0 -save=2 -pos=bottom -mode=0 python -m maketraderunit --rocket -d - j 12 <cr>

" dos2unix
"nnoremap <silent> <F9> :%s/$//g<CR>:%s// /g<CR>
nnoremap <silent> <F9> :AsyncStop<CR>

nnoremap <silent> <F11> :call NextColor(-1)<CR>
nnoremap <silent> <F12> :call NextColor(1)<CR>

"if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat+=%f:%l:%c:%m
  let g:ackgrp = 'rg -H --noheading --vimgrep'
"endif

" Write as sudo
cmap w!! w !sudo tee '%' > /dev/null

"type :PlugUpdate to update them
call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
cnoreabbrev Ack Ack!
"nnoremap <Leader>a :Ack!<Space>
nnoremap <Leader>a :Ack <cword><cr>

Plug 'ctrlpvim/ctrlp.vim'
if executable('rg')
  " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'

  " rg is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
Plug 'jszakmeister/vim-togglecursor'
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'ray-x/aurora'
let g:aurora_darker = 1
Plug 'ryanoasis/vim-devicons'
Plug 'skywind3000/asyncrun.vim'
"Number of line of output window (e.g. when invoking make)
let g:asyncrun_open = 20
"let g:asyncrun_encs = 'utf-8'

Plug 'tpope/vim-fugitive'
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>ga :Gcommit --amend<CR>
nnoremap <leader>gt :Gcommit -v -q %<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>
Plug 'vim-syntastic/syntastic', { 'for' : [ 'cpp', 'c', 'h', 'hpp' ] }
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
"let g:airline_section_c = '%{expand(''%:F'')}'
"Plug 'Valloric/YouCompleteMe'
""set rtp+=~/.vim/plugged/YouCompleteMe
"let g:loaded_youcompleteme = 1
"let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py"
"Plug 'jszakmeister/vim-togglecursor'
Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=gray5 " ctermbg=gray5
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=black " ctermbg=black

Plug 'yegappan/mru'
nnoremap <S-m> :MRU<CR>
call plug#end()

packadd termdebug



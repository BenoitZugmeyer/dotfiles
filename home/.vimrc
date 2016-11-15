
set nocompatible               " be iMproved, required for vundle
filetype off                   " required for vundle

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Syntax, indent...
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-git'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'groenewege/vim-less'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'rust-lang/rust.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'

" Edition helper
Plugin 'tpope/vim-commentary'
Plugin 'easymotion/vim-easymotion'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'vis'
Plugin 'chrisbra/unicode.vim'

" Other
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'slack/vim-l9'
Plugin 'scrooloose/syntastic'
Plugin 'joonty/vdebug'
Plugin 'vim-scripts/vimwiki'
Plugin 'tpope/vim-vinegar'
Plugin 'vim-airline/vim-airline'

Plugin 'junegunn/vim-easy-align'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/vim-peekaboo'

Plugin 'morhetz/gruvbox'


" Unused, but to keep in mind
" Plugin 'altercation/vim-colors-solarized'
" Plugin 'hallettj/jslint.vim'
" Plugin 'mileszs/ack.vim'
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Plugin 'sjl/gundo.vim'
" Plugin 'tpope/vim-pathogen'
" Plugin 'tpope/vim-vividchalk'
" Plugin 'vim-scripts/pep8'

call vundle#end()            " required for vundle
filetype plugin indent on    " required for vundle

syntax on                     " syntax highlighing
set synmaxcol=450
set omnifunc=syntaxcomplete#Complete
set number                    " Display line numbers
set numberwidth=1             " using only 1 column (and 1 space) while possible
set background=dark           " We are using dark background in vim
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set t_Co=256
set termguicolors

let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italic=1
let g:gruvbox_number_column="bg1"
colorscheme gruvbox

" don't bell or blink
set noerrorbells
set vb t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set grepprg=ack-grep          " replace the default grep program with ack

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=menuone,longest,preview
set pumheight=6             " Keep a small completion window

""" Moving Around/Editing
set cursorline              " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set wrap                  " don't wrap text
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set tabstop=4               " <tab> inserts 4 spaces
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default
set hidden     " The current buffer can be put to the background without writing to disk
set history=1000

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.

"""" Messages, Info, Status
set ls=2                    " allways show status line
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set laststatus=2            " Always show statusline, even if only 1 window.
set statusline=%<%{fugitive#statusline()}\ %F\ %M%R%H
set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
set statusline+=%=%{&ff}%Y,%{&fenc}\ \|\ %l/%L:%v\ %P\ 
set colorcolumn=100
set textwidth=100

" displays tabs with :set list & displays when a line runs off-screen
"set listchars=tab:⋮\ ,trail:•,precedes:<,extends:>
set listchars=tab:»\ ,trail:•,precedes:<,extends:>
set list

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

set backupcopy=yes
set clipboard=unnamedplus
set formatoptions=croqlj

" Always use one window for netrw
let g:netrw_chgwin=1

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers=["jsxhint"]
let g:syntastic_javascript_jshint_args = "--extract auto"
let g:syntastic_javascript_jsxhint_args = "--extract auto --harmony"

let g:syntastic_auto_jump=0
let g:syntastic_stl_format = 'Error line %F (%t)'

let g:airline_powerline_fonts = 1

augroup resCur
    autocmd!
    autocmd BufWinLeave ?* if &filetype!=#'netrw' | mkview | endif
    autocmd BufWinEnter ?* if &filetype!=#'netrw' | silent loadview | endif
augroup END

" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Smart cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


" Match html tags the same way than () {} (among other)
runtime macros/matchit.vim

let mapleader=","             " change the leader to be a comma vs slash

map <Leader> <Plug>(easymotion-prefix)

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" sudo write this
cnoremap W! w !sudo tee % >/dev/null

" ctrl-jklm  changes to that split
noremap <c-left>  <c-w>h
noremap <c-down>  <c-w>j
noremap <c-up>    <c-w>k
noremap <c-right> <c-w>l
" and lets make these all work in insert mode too ( <C-O> makes next cmd
"  happen as if in command mode )
inoremap <C-W> <C-O><C-W>

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" don't outdent hashes
inoremap # #



" Smarter home key
noremap <Home> ^
noremap ^ <Home>
inoremap <Home> <C-O>^

" Quick diff between buffer and file
nnoremap <Leader>d :w !diff % -<CR>
" Clear search (highlights)
nnoremap <silent> <Leader><space> :let @/ = ""<Return>
nnoremap <silent> <Leader>s ms:%s/\s\s*$//g<Return>'szz

nnoremap <Leader>js ms
    \ :%s/\s\s*$//ge<Return>
    \ :%s/){/) {/ge<Return>
    \ :%s/\<function(/function (/ge<Return>
    \ :%s/\<if(/if (/ge<Return>
    \ :%s/}\n\s*else/} else/ge<Return>
    \ 'szz

" Select previously pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Select previously entered text
nnoremap gV `[v`]

nnoremap <C-w> :<C-u>Files<cr>
inoremap <C-w> <C-o>:<C-u>Files<cr>
nnoremap <C-x> :<C-u>Buffers<cr>
inoremap <C-x> <C-o>:<C-u>Buffers<cr>
nnoremap <C-c> :<C-u>History<cr>
inoremap <C-c> <C-o>:<C-u>History<cr>

imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Keep visual selection on indent
vnoremap < <gv
vnoremap > >gv

" Focus on current scope
nnoremap <leader>z zMzvzczOzz
nnoremap <Space> za

nnoremap <leader>cd :cd %:p:h<cr>

" dvorak specific
noremap ; :

cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

vnoremap p pgvy

let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsDontReverseSearchPath=1

autocmd! FileType css,scss setl iskeyword+=-

" Use ranger r vim file manager
function! Ranger()
    silent !ranger --choosefile=/tmp/chosen %:p:h
    if filereadable('/tmp/chosen')
        exec 'edit ' . system('cat /tmp/chosen')
        call system('rm /tmp/chosen')
    endif
    redraw!
endfunction
nmap <leader>o :call Ranger()<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

" expand tabs into spaces
    let onetab = strpart(' ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

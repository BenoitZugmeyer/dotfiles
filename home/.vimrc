if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

" Syntax, indent...
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-git'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mitsuhiko/vim-jinja'
Plug 'groenewege/vim-less'
Plug 'hynek/vim-python-pep8-indent'
Plug 'rust-lang/rust.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'cespare/vim-toml'
Plug 'leafgarland/typescript-vim'

" Edition helper
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-scripts/vis'
Plug 'chrisbra/unicode.vim'
Plug 'sbdchd/neoformat'

" Other
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'slack/vim-l9'
Plug 'w0rp/ale'
Plug 'joonty/vdebug'
Plug 'vim-scripts/vimwiki'
Plug 'justinmk/vim-dirvish'
Plug 'vim-airline/vim-airline'

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-journal'

Plug 'morhetz/gruvbox'


" Unused, but to keep in mind
" Plug 'altercation/vim-colors-solarized'
" Plug 'hallettj/jslint.vim'
" Plug 'mileszs/ack.vim'
" Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" Plug 'sjl/gundo.vim'
" Plug 'tpope/vim-pathogen'
" Plug 'tpope/vim-vividchalk'
" Plug 'vim-scripts/pep8'

call plug#end()

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
set statusline+=%#warningmsg#%{ALEGetStatusLine()}%*
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

" ALE
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \}
nmap <silent> <C-p> <Plug>(ale_previous_wrap)
nmap <silent> <C-n> <Plug>(ale_next_wrap)
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
" GruvboxOrange
highlight ALEWarningSign term=underline ctermfg=208 ctermbg=237 guifg=#fe8019 guibg=#3c3836
" GruvboxRed
highlight ALEErrorSign term=underline ctermfg=167 ctermbg=237 guifg=#fb4934 guibg=#3c3836

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

nnoremap <F1> :<C-u>Files<cr>
inoremap <F1> <C-o>:<C-u>Files<cr>
nnoremap <F2> :<C-u>Buffers<cr>
inoremap <F2> <C-o>:<C-u>Buffers<cr>
nnoremap <F3> :<C-u>History<cr>
inoremap <F3> <C-o>:<C-u>History<cr>
nnoremap <F4> :<C-u>Neoformat<cr>
inoremap <F4> <C-o>:<C-u>Neoformat<cr>

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

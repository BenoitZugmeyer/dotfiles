
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" Syntax, indent...
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-git'
Bundle 'othree/html5.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'
Bundle 'mitsuhiko/vim-jinja'
Bundle 'groenewege/vim-less'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'mozilla/rust', {'rtp': 'src/etc/vim'}
Bundle 'editorconfig/editorconfig-vim'
Bundle 'octol/vim-cpp-enhanced-highlight'

" Edition helper
Bundle 'tsaleh/vim-align'
Bundle 'tpope/vim-commentary'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'vis'
Bundle 'chrisbra/unicode.vim'

" Other
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'
Bundle 'slack/vim-l9'
Bundle 'scrooloose/syntastic'
Bundle 'mikewest/vimroom'
Bundle 'joonty/vdebug'
Bundle 'vim-scripts/vimwiki'
Bundle 'tpope/vim-vinegar'

Bundle 'tacahiroy/ctrlp-funky'
Bundle 'mattn/ctrlp-register'

Bundle 'junegunn/vim-easy-align'

" Unused, but to keep in mind
" Bundle 'altercation/vim-colors-solarized'
" Bundle 'hallettj/jslint.vim'
" Bundle 'mileszs/ack.vim'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'sjl/gundo.vim'
" Bundle 'tpope/vim-pathogen'
" Bundle 'tpope/vim-vividchalk'
" Bundle 'vim-scripts/pep8'


filetype plugin indent on     " required!


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
colorscheme alk

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

let g:syntastic_javascript_checkers=["jsxhint"]
let g:syntastic_javascript_jshint_args = "--extract auto"
let g:syntastic_javascript_jsxhint_args = "--extract auto --harmony"

let g:syntastic_auto_jump=0
let g:syntastic_stl_format = 'Error line %F (%t)'

let g:ctrlp_by_filename = 1
let g:ctrlp_max_height = 20
let g:ctrlp_prompt_mappings = {
  \ 'PrtBS()':      ['<bs>', '<c-]>', '<c-h>'],
  \ 'PrtCurLeft()': ['<left>', '<c-^>'],
  \ }
let g:ctrlp_max_files = 0
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']
let g:ctrlp_mruf_max = 10000
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.vim/cache_ctrlp'

" Restore cursor position on opening a file
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
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

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" sudo write this
cnoremap W! w !sudo tee % >/dev/null

" ctrl-jklm  changes to that split
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l
noremap <c-h> <c-w>h
noremap <c-left> <c-w>h
noremap <c-down> <c-w>j
noremap <c-up> <c-w>k
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

" Move current line up and down
nnoremap - ddp
nnoremap _ ddkP

" Select previously pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Select previously entered text
nnoremap gV `[v`]

" Open file
noremap <F1> :CtrlPMixed<cr>
inoremap <F1> <C-o>:CtrlPMixed<cr>
noremap <F2> :CtrlPBuffer<cr>
inoremap <F2> <C-o>:CtrlPBuffer<cr>

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

"nnoremap <silent><C-o> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-S-o> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-o>   :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-O> :set paste<CR>m`O<Esc>``:set nopaste<CR>

inoremap kk <Esc>
noremap k :w<CR>




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



""" FocusMode
let g:vimroom_width = &colorcolumn - 1
function! ToggleFocusMode()
    set noruler
    set nolist
    GitGutterToggle
    VimroomToggle
endfunc
nnoremap <F3> :call ToggleFocusMode()<cr>


nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_javascript = {
    \ 'ctagsbin' : '/home/alk/doctorjs/bin/jsctags.js'
    \ }

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
" Restore cursor position on opening a file
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END



function! Reg()
    reg
    echo "Register: "
    let char = nr2char(getchar())
    if char != "\<Esc>"
        execute "normal! \"".char."p"
    endif
    redraw
endfunction

command! -nargs=0 Reg call Reg()


function! ExtractLocalVariable()
    let name = input("Variable name: ")

    if (visualmode() == "")
        normal! viw
    else
        normal! gv
    endif

    exec "normal! c" . name
    let selection = @"
    exec "normal! Ovar " . name . " = "
    exec "normal! pa;"
    call feedkeys(':.+1,$s/\V\C' . escape(selection, '/\') . '/' . escape(name, '/\') . "/gec\<cr>")
endfunction

vnoremap r :call ExtractLocalVariable()<CR>

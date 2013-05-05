
call pathogen#infect()
set nocompatible              " Don't be compatible with vi

syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
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

" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:⋮\ ,trail:•,precedes:<,extends:>
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

let g:syntastic_auto_jump=1
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


"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

" ACP related stuff. Deactivate for now.
" Don't allow snipmate to take over tab
"autocmd VimEnter * ino <c-j> <c-r>=TriggerSnippet()<cr>
" Use tab to scroll through autocomplete menus
"autocmd VimEnter * imap <expr> <Tab> pumvisible() ? "<C-N>" : "<Tab>"
"autocmd VimEnter * imap <expr> <S-Tab> pumvisible() ? "<C-P>" : "<S-Tab>"
"snor <c-j> <esc>i<right><c-r>=TriggerSnippet()<cr>
"let g:acp_completeoptPreview=1
" Select the item in the list with enter
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


let g:statusLineText=""
noremap <F5> :bN<CR>
noremap <F6> :bn<CR>
inoremap <F5> <esc>:bN<cr>
inoremap <F6> <esc>:bn<cr>

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

" Open file
noremap <F1> :CtrlPMixed<cr>
inoremap <F1> <C-o>:CtrlPMixed<cr>
noremap <F2> :CtrlPBuffer<cr>
inoremap <F2> <C-o>:CtrlPBuffer<cr>

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Clipboard
" nnoremap <C-F3>   "+yy
" vnoremap <C-F3>   "+y
" noremap  <C-F4>   "+gp
" inoremap <C-F3>   <c-o>"+yy
" inoremap <C-F4>   <c-o>"+gp

" Primary selection
" nnoremap <F3> "*yy
" vnoremap <F3> "*y
" noremap  <F4> "*gp
" inoremap <F3> <c-o>"*yy
" inoremap <F4> <c-o>"*gp

" Usefull for working on themes
function! SynStack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc
nnoremap <C-s> :call SynStack()<CR>

" Focus on current scope
nnoremap <leader>z zMzvzczOzz
nnoremap <Space> za

" dvorak specific
noremap ; :

"nnoremap <silent><C-o> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-S-o> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-o>   :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-O> :set paste<CR>m`O<Esc>``:set nopaste<CR>

inoremap kk <Esc>
noremap k :w<CR>

" Surround comments with character /
let g:surround_47 = "/* \r */"



""" FocusMode
let g:vimroom_width = &colorcolumn - 1
function! ToggleFocusMode()
    set noruler
    set nolist
    call DisableGitGutter()
    VimroomToggle
endfunc
nnoremap <F3> :call ToggleFocusMode()<cr>

cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

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

vnoremap p pgvy


set nocompatible
set encoding=utf-8
set history=50
" Tell vim to remember certain things when we exit
" "  '10  :  marks will be remembered for up to 10 previously edited files
" "  "100 :  will save up to 100 lines for each register
" "  :20  :  up to 20 lines of command-line history will be remembered
" "  %    :  saves and restores the buffer list
" "  n... :  where to save the viminfo files
set viminfo='20,\"100,:20,%,n~/.viminfo
set title
set modeline

set autowrite
set autoread

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent

colorscheme darkburn
set background=dark
set t_Co=256
syntax on

filetype on
filetype plugin on
filetype indent on

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

map T :TaskList<CR>
map P :TlistToggle<CR>

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#CompleteCpp

autocmd FileType mak setlocal noexpandtab

au! BufWritePost .vimrc source %

au BufNewFile,BufRead *.li setf lisaac

set backup
set backupcopy=yes
set backupdir=~/.vim/backup
set directory=~/.vim/temp
set makeef=error.err

set laststatus=2
set statusline=%<%F%=[%{&ff}%Y,%{&fenc}]\ [%1*%M%R%0*%n%W]\ [POS=%03v,%04l/%04L\ %P]

set listchars=nbsp:•,tab:⋮\ ,trail:•,extends:>,precedes:<
set list

set scrolloff=15
let mapleader = "\<F12>"
nnoremap <C-C> :q<cr>

noremap <F5> :tabN<cr>
noremap <F6> :tabn<cr>
inoremap <F5> <esc>:tabN<cr>
inoremap <F6> <esc>:tabn<cr>
noremap ù %

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

set colorcolumn=80
hi ColorColumn ctermbg=236 guibg=#2d2d2d

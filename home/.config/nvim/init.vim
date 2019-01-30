if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" Syntax, indent...
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'editorconfig/editorconfig-vim'
Plug 'cespare/vim-toml'
"Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'dart-lang/dart-vim-plugin'
Plug 'posva/vim-vue'
Plug 'nikvdp/ejs-syntax'

" Linters and stuff
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'w0rp/ale'

" Edition helper
Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'suy/vim-context-commentstring'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Other
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-sensible'
Plug 'djoshea/vim-autoread'

call plug#end()

let mapleader=","
set background=dark
set termguicolors
set nostartofline
set clipboard=unnamedplus
set hidden
set nobackup
set nowritebackup
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set colorcolumn=100
set textwidth=100
set listchars=tab:»\ ,trail:•,precedes:<,extends:>,nbsp:+
set list
set ignorecase
set smartcase

" Increased list of file to use with fzf History command (v:oldfiles variable)
set shada=!,'10000,<50,s10,h
set formatoptions=croqlj
set viewoptions=cursor,folds
set number
set numberwidth=1

let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italic=1
let g:gruvbox_number_column="bg1"
colorscheme gruvbox

" Match html tags the same way than () {} (among other)
runtime macros/matchit.vim

map <Leader> <Plug>(easymotion-prefix)

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
" don't outdent hashes
inoremap # #
nnoremap <F1> :<C-u>Files<cr>
inoremap <F1> <C-o>:<C-u>Files<cr>
nnoremap <F2> :<C-u>Buffers<cr>
inoremap <F2> <C-o>:<C-u>Buffers<cr>
nnoremap <F3> :<C-u>History<cr>
inoremap <F3> <C-o>:<C-u>History<cr>
nnoremap <F4> :<C-u>ALEFix<cr>
inoremap <F4> <C-o>:<C-u>ALEFix<cr>
nnoremap <silent> <cr> :call LanguageClient_textDocument_hover()<cr>
nnoremap <Home> ^
inoremap <Home> <C-O>^
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <Leader>r :source $MYVIMRC<CR>
nnoremap <silent> <Leader>s ms:%s/\s\s*$//g<Return>'szz

" Keep visual selection on indent
vnoremap < <gv
vnoremap > >gv
vnoremap p pgvy
" Select previously pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Select previously entered text
nnoremap gV `[v`]

cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

" Focus on current scope
nnoremap <leader>z zMzvzczOzz
nnoremap <Space> za

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ 'dart': ['dart_language_server'],
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'typescript': ['typescript-language-server', '--stdio'],
    \ 'typescript.tsx': ['typescript-language-server', '--stdio'],
    \ }
    " \ 'javascript': ['javascript-typescript-stdio'],
    " \ 'typescript': ['javascript-typescript-stdio'],
" let g:LanguageClient_trace = 'verbose'
" let g:LanguageClient_windowLogMessageLevel = 'Log'
" let g:LanguageClient_loggingLevel = 'DEBUG'
" let g:LanguageClient_loggingLevel = 'DEBUG'
" let g:LanguageClient_loggingFile = expand('~/.local/share/nvim/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')

" Disable deoplete in most cases
call deoplete#custom#option('auto_complete', v:false)


call ale#linter#Define('html', {
\   'name': 'eslint',
\   'output_stream': 'both',
\   'executable_callback': 'ale#handlers#eslint#GetExecutable',
\   'command_callback': 'ale#handlers#eslint#GetCommand',
\   'callback': 'ale#handlers#eslint#Handle',
\})
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \   'typescript': ['tsserver'],
            \   'html': ['eslint'],
            \   'dart': [],
            \}
let g:ale_fixers = {
            \   'javascript': ['eslint'],
            \   'vue': ['eslint'],
            \   'rust': ['rustfmt'],
            \   'html': ['tidy'],
            \   'typescript': ['prettier'],
            \   'css': ['prettier'],
            \   'dart': ['dartfmt'],
            \}

" Smart cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" Prefer LanguageClient for typescript
augroup typescript_cfg
    autocmd!
    autocmd filetype typescript let b:ale_enabled=0
    autocmd filetype typescript nnoremap <buffer> <F4> :call LanguageClient_textDocument_formatting()<cr>
    autocmd filetype typescript call deoplete#enable()
    autocmd filetype typescript call deoplete#custom#buffer_option('auto_complete', v:true)
    autocmd filetype typescript.tsx let b:ale_enabled=0
    autocmd filetype typescript.tsx nnoremap <buffer> <F4> :call LanguageClient_textDocument_formatting()<cr>
    autocmd filetype typescript.tsx call deoplete#enable()
    autocmd filetype typescript.tsx call deoplete#custom#buffer_option('auto_complete', v:true)
augroup END

" https://github.com/leafgarland/typescript-vim/pull/140
" autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

nmap <silent> <C-p> <Plug>(ale_previous_wrap)
nmap <silent> <C-n> <Plug>(ale_next_wrap)
let g:ale_sign_error = '●'
let g:ale_sign_warning = '●'
" GruvboxOrange
highlight ALEWarningSign term=underline ctermfg=208 ctermbg=237 guifg=#fe8019 guibg=#3c3836
" GruvboxRed
highlight ALEErrorSign term=underline ctermfg=167 ctermbg=237 guifg=#fb4934 guibg=#3c3836


autocmd! FileType css,scss setl iskeyword+=-
autocmd FileType vue syntax sync fromstart
autocmd FileType ocaml setl commentstring=(*%s*)

let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsDontReverseSearchPath=1

let g:EditorConfig_exclude_patterns = ['fugitive://.*', '.*\.diff$']

" check https://github.com/vim-airline/vim-airline/blob/902921931e1048aacb4a256cb6ff1290ec3a5ce7/autoload/airline/init.vim#L190
call airline#parts#define('linenr', { 'raw': '%l', 'accent': 'bold'})
call airline#parts#define('maxlinenr', { 'raw': '/%L', 'accent': 'bold'})
let g:airline_section_z = airline#section#create(['windowswap', 'obsession', 'linenr', 'maxlinenr', ':%v'])

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Restore cursor position on opening a file
augroup resCur
    autocmd!
    autocmd BufWinLeave ?* mkview
    autocmd BufWinEnter ?* silent! loadview
augroup END

" Usefull for working on themes
function! SynStack()
    echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc
nnoremap <C-s> :call SynStack()<CR>

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

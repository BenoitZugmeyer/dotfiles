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
Plug 'HerringtonDarkholme/yats.vim'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'dart-lang/dart-vim-plugin'
Plug 'posva/vim-vue'
Plug 'nikvdp/ejs-syntax'

" Edition helper
Plug 'vim-airline/vim-airline'
Plug 'suy/vim-context-commentstring'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" CocInstall coc-tsserver
" CocInstall coc-git
" CocInstall coc-yank
" CocInstall coc-snippets

" Other
Plug 'tpope/vim-fugitive'
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-sensible'
Plug 'djoshea/vim-autoread'

call plug#end()

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
set rtp+=/usr/local/opt/fzf
set shada=!,'10000,<50,s10,h
set formatoptions=croqlj
set viewoptions=cursor,folds
set number
set numberwidth=1
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

let mapleader=","

let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italic=1
let g:gruvbox_number_column="bg1"
colorscheme gruvbox

" Match html tags the same way than () {} (among other)
runtime macros/matchit.vim

map <Leader> <Plug>(easymotion-prefix)

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

nnoremap <Home> ^
inoremap <Home> <C-O>^
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <silent> <Leader>s ms:%s/\s\s*$//g<Return>'szz

" Keep visual selection on indent
vnoremap < <gv
vnoremap > >gv
vnoremap p pgvy
" Select previously pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Select previously entered text
nnoremap gV `[v`]

" sudo write this
cnoremap W! w !sudo tee % >/dev/null
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

" Focus on current scope
nnoremap <leader>z zMzvzczOzz
nnoremap <Space> za

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-n> <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>d <Plug>(coc-definition)
nmap <silent> <Leader>D <Plug>(coc-type-definition)
nmap <silent> <Leader>i <Plug>(coc-implementation)
nmap <silent> <Leader>I <Plug>(coc-references)

nnoremap <silent> <cr> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<tab>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<s-tab>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <tab> <Plug>(coc-snippets-expand-jump)

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Smart cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

autocmd! FileType css,scss setl iskeyword+=-
autocmd FileType vue syntax sync fromstart
autocmd FileType ocaml setl commentstring=(*%s*)

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
    let btToIgnore = ['terminal']
    autocmd BufWinLeave ?* if index(btToIgnore, &buftype) < 0 | mkview 1
    autocmd BufWinEnter ?* silent! loadview 1
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

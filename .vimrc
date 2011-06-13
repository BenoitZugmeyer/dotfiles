"------------------------------"
"Configuration de VIM : 
"------------------------------"
"
" dim. févr. 21 11:44:39 CET 2010
" Notes pour Simon : 
"  -> j'ai commencé à faire les notes un peu tard, alors y'a des trucs que j'ai
"  pas repris de chez toi... ça serait bien qu'on fasse des allez-retour de
"  vimrc histoire d'avoir un truc béton :D
"  -> je fais ça rapidos pour te répondre, donc il est pas encore nickel. En
"  même temps, ça permettra peut-être des ajustements plus rapidement ;)
"  -> je maitrise pas à fond le mappage des commandes
"
"  -> pas de set hid : buffer hidden (pourquoi t'utilises ça ? malheureux !)
"  -> pas de set ignorecase smartcase
"  -> je voit pas à quoi ça sert : 
"    cnoremap <Left> <Space><BS><Left>
"    cnoremap <Right> <Space><BS><Right>
"
"  -> je te laisse remettre les commandes pour :make, quickfix, toussa....

"------------------------------"
" General :
"------------------------------"
set nocompatible                " Mode vim (et pas vi) ;
set encoding=utf-8              " Codage des caractères en unicode
set history=50                  " 50 commandes dans l'historique.
" Tell vim to remember certain things when we exit
" "  '10  :  marks will be remembered for up to 10 previously edited files
" "  "100 :  will save up to 100 lines for each register
" "  :20  :  up to 20 lines of command-line history will be remembered
" "  %    :  saves and restores the buffer list
" "  n... :  where to save the viminfo files
set viminfo='20,\"100,:20,%,n~/.viminfo
set title                       " Mise à jour du titre du terminal, si possible.
set modeline        " Lecture d'infos (premièreS et dernièreS lignes) à l'ouverture d'un fichier ;

set autowrite   " Sauvegarde automatique (:next, :make..) ;
set autoread    " Relecture automagique des fichiers modifiés

set expandtab
"set textwidth=79
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent

colorscheme darkburn
set background=dark  " Fond =light/=dark ;
set t_Co=256
syntax on

filetype on         " Détection du type de fichier activée ;
filetype plugin on  " Chargement des greffons en fonction du type de fichier ;
filetype indent on  " Chargement des indentations en fonction du type de fichier.


set listchars=nbsp:¤,tab:>-,trail:¤,extends:>,precedes:<
set list                " je connaissais pas, c'est cool ça ! par contre, faudrait mapper un truc pour activer/désactiver pour le copier/coller

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

au! BufWritePost .vimrc source %    " Suppression des autres autocmd sur BufNewFile, rechargement.

au BufNewFile,BufRead *.li setf lisaac 

"------------------------------"
" Sauvegardes :
"------------------------------"
set backup                    " Faire des sauvegardes ;
set backupcopy=yes            " Mode de sauvegarde (lent mais sûr pour attribut des fichiers)
set backupdir=~/.vim/backup/  " Où les faires ;
set directory=~/.vim/temp     " Répertoire temporaire de vi ;
set makeef=error.err          " Erreur de make.



set laststatus=2    " Toujours avoir la barre de statut
set statusline=%<%F%=[%{&ff}%Y,%{&fenc}]\ [%1*%M%R%0*%n%W]\ [POS=%03v,%04l/%04L\ %P]

set listchars=nbsp:•,tab:>-,trail:•,extends:>,precedes:<
set list                " je connaissais pas, c'est cool ça ! par contre, faudrait mapper un truc pour activer/désactiver pour le copier/coller

set scrolloff=15    " Garder 15 lignes autour du curseur ;
let mapleader = "\<F12>"
nnoremap <C-C> :q<cr>


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



set colorcolumn=81
hi ColorColumn ctermbg=236 guibg=#2d2d2d

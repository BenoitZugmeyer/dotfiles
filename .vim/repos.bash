#!/bin/bash

# {{{ Functions definition

set -e

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPOS=$DIR/repos
if [[ $1 == update ]]; then
    update=true
else
    update=false
fi

files=()

register () {
    path=$1
    if [[ $path != $DIR/* ]]; then
        path=$DIR/$path
    fi
    files+=(-or -path "$path")
}

checkout () {
    current=$(rgit status --porcelain -b | grep -Po '## \K[^ ]*')
    if [[ $current != $1 ]]; then
        rgit checkout $1
    fi
}

rgit () {
    git --git-dir=$path/.git --work-tree=$path $*
}

repo () {
    path=$REPOS/$1
    branch=${3-master}

    echo "REPO $1"

    if [[ -d $path ]]; then
        checkout $branch
        if $update; then
            echo "Updating..."
            rgit pull --rebase
        fi
    else
        echo "Cloning..."
        git clone $2 $path
        checkout $branch
    fi

    register $path
    register "$path/*"
}

error () {
    echo ERROR: $*
    exit 1
}

sym () {
    from=$REPOS/$1
    to=$DIR/${2-bundle}

    if [[ -d $to ]] && ! [[ -L $to ]]; then
        to=$to/$(basename $from)
    fi

    if [[ -L $to ]]; then
        if [[ $(readlink -f $to) != $from ]]; then
            error $to exists and its destination is not $from
        fi
    elif [[ -e $to ]]; then
        error $to exists
    else
        echo "Symlink $from -> $to"
        ln -s $from $to
    fi

    register $to
}

dir () {
    mkdir -p $DIR/$1
    register $DIR/$1
}

# }}}

dir repos
dir autoload
dir bundle
dir tmp

repo pathogen          https://github.com/tpope/vim-pathogen.git
repo ctrlp             https://github.com/kien/ctrlp.vim
repo fugitive          https://github.com/tpope/vim-fugitive.git
repo git               https://github.com/tpope/vim-git.git
repo gundo             https://github.com/sjl/gundo.vim.git
repo align             https://github.com/tsaleh/vim-align.git
repo javascript        https://github.com/pangloss/vim-javascript.git
repo coffeescript      https://github.com/kchmck/vim-coffee-script.git
repo jslint            https://github.com/hallettj/jslint.vim.git
repo l9                https://github.com/slack/vim-l9.git
repo rust              https://github.com/mozilla/rust.git
repo solarized         https://github.com/altercation/vim-colors-solarized.git
repo surround          https://github.com/tpope/vim-surround.git
repo pep8              https://github.com/vim-scripts/pep8.git
repo ack               https://github.com/mileszs/ack.vim.git
repo vividchalk        https://github.com/tpope/vim-vividchalk.git
repo vimroom           https://github.com/mikewest/vimroom.git
repo vimwiki           https://github.com/vim-scripts/vimwiki.git
repo syntastic         https://github.com/scrooloose/syntastic.git

repo snipmate          https://github.com/garbas/vim-snipmate.git # forked version
repo tlib              https://github.com/tomtom/tlib_vim.git
repo addon-mw-utils    https://github.com/MarcWeber/vim-addon-mw-utils.git
repo snipmate-snippets https://github.com/honza/snipmate-snippets.git


sym pathogen/autoload/pathogen.vim autoload
sym ctrlp
sym fugitive
sym surround
sym git
sym l9
sym javascript
sym rust/src/etc/vim bundle/rust
sym coffeescript
sym vimroom
sym vimwiki
sym syntastic

sym snipmate
sym addon-mw-utils
sym tlib
sym snipmate-snippets

register "tmp/*"
register repos.bash

# TODO find git source for lisaac
register syntax
register syntax/lisaac.vim
register indent
register indent/lisaac.vim

register snippets
register "snippets/*"

register colors
register colors/alk.vim
register colors/zenburn.vim
register colors/darkburn.vim
register colors/desert256.vim

# TODO put this is .vimrc
register ftplugin
register ftplugin/html.vim
register ftplugin/javascript.vim
register ftplugin/coffee.vim

register .netrwhist

echo "Untracked files and directories:"
find $DIR -not \( -path $DIR "${files[@]}" \) -prune -printf "  %P\n"

# vim: set fdm=marker fdl=0:

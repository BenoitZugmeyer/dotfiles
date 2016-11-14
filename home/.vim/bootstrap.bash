#!/bin/bash

set -e

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $DIR/tmp
mkdir -p $DIR/cache_ctrlp

if ! [ -e $DIR/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $DIR/bundle/Vundle.vim
fi

vim +BundleInstall +qall

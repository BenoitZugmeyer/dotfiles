#!/bin/bash

set -e

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $DIR/tmp
mkdir -p $DIR/cache_ctrlp

if ! [ -e $DIR/bundle/vundle ]; then
    git clone https://github.com/gmarik/vundle.git $DIR/bundle/vundle
fi

vim +BundleInstall +qall

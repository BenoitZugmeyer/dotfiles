#!/bin/bash

set -e

ROOT=$(cd `dirname $0` && pwd)
SCRIPT=$(basename $0)

IGNORE="
.gitmodules
.gitignore
.netrc
README.rst
$SCRIPT
"
FORCE=false
if [[ $1 == '-f' ]]; then
    FORCE=true
fi

inode () {
    ls -i "$1" | cut -d' ' -f1
}

hash () {
    openssl md5 "$1" | tail -c32
}

lgit () {
    git --work-tree="$ROOT" --git-dir="$ROOT/.git" "$@"
}

while read file; do

    base=$(basename "$file")
    directory=$(dirname "$file")

    [[ "$IGNORE" == *"$base"* ]] && continue

    if ! [[ -d "$HOME/$directory" ]]; then
        echo "$directory -> creating directory"
        mkdir -p "$HOME/$directory"
    fi

    [[ -d "$ROOT/$file" ]] && continue

    if [ -e "$HOME/$file" ]; then
        if [[ `inode "$ROOT/$file"` != `inode "$HOME/$file"` ]]; then
            echo -n "$file -> different inode "
            if $FORCE || [[ `hash "$ROOT/$file"` == `hash "$HOME/$file"` ]]; then
                echo "same hash, fixing this"
                rm -f "$HOME/$file" && ln "$ROOT/$file" "$HOME/$file"
            elif [[ -z $(lgit status --porcelain "$ROOT/$file") ]]; then
                echo "no modification in repo, copying this"
                rm -f "$ROOT/$file" && ln "$HOME/$file" "$ROOT/$file"
            else
                echo "not same hash, ignoring"
            fi
        fi
    else
        echo "$file -> creating"
        ln "$ROOT/$file" "$HOME/$file"
    fi

done < <(lgit ls-files)


#!/bin/bash

set -euo pipefail

ROOT=$(cd $(dirname $0) && pwd)
SCRIPT=$(basename $0)


SHORT=fn
LONG=force,dry-run
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
eval set -- "$PARSED"

FORCE=false
DRY_RUN=false

while true; do
    case "$1" in
        -f|--force)
            FORCE=true
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [[ ${#} -eq 0 ]] || [[ "${1}" != root ]] && [[ "${1}" != home ]] ; then
    echo "Usage: $0 [-f | --force] [-n | --dry-run] root | home"
    exit 1
fi

function run () {
    if $DRY_RUN; then
        echo "#" "${@}"
    else
        ${@}
    fi
}

function inode () {
    ls -i "$1" | cut -d' ' -f1
}

function hash () {
    openssl md5 "$1" | tail -c32
}

function lgit () {
    git --work-tree="$ROOT" --git-dir="$ROOT/.git" "$@"
}

function deploy () {
    local tree="$1"
    local target="$2"

    while read file; do

        local base=$(basename "$file")
        local directory=$(dirname "$file")

        if [[ -L "$target/$file" ]]; then
            if ! [[ -e "$target/$file" ]]; then
                echo "$file -> broken symlink, removing"
                run rm "$target/$file"
            fi
        fi

        if ! [[ -d "$target/$directory" ]]; then
            echo "$directory -> creating directory"
            run mkdir -p "$target/$directory"
        fi

        [[ -d "$tree/$file" ]] && continue

        if [ -e "$target/$file" ]; then
            if [[ $(inode "$tree/$file") != $(inode "$target/$file") ]]; then
                echo -n "$file -> different inode "
                if $FORCE || [[ $(hash "$tree/$file") == $(hash "$target/$file") ]]; then
                    echo "same hash, fixing this"
                    run rm -f "$target/$file"
                    run ln "$tree/$file" "$target/$file"
                elif [[ -z $(lgit status --porcelain "$tree/$file") ]]; then
                    echo "no modification in repo, copying this"
                    run rm -f "$tree/$file"
                    run ln "$target/$file" "$tree/$file"
                else
                    echo "not same hash, ignoring"
                fi
            fi
        else
            echo "$file -> creating"
            run ln "$tree/$file" "$target/$file"
        fi

    done < <(cd "$tree"; lgit ls-files)
}

case "$1" in
    home) deploy "$ROOT/home" "$HOME" ;;
    root) deploy "$ROOT/root" / ;;
esac

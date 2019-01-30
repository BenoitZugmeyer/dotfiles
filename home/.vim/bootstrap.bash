#!/bin/bash

set -e

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $DIR/tmp
mkdir -p $DIR/cache_ctrlp

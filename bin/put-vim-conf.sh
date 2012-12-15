#!/bin/bash

DEST="$(pwd)/t2/open-source/projects/conf/vim"
CURRENT="$DEST/current"
mkdir -p "$CURRENT" "$CURRENT/conf/Vim"

cp -f "$HOME/.vimrc" "$CURRENT/vimrc"
rsync -av --delete-after "$HOME/conf/Vim" "$CURRENT/conf/"
(cd $HOME/.vim && tar -cYvf - .) > "$CURRENT/dot-vim.lzma"


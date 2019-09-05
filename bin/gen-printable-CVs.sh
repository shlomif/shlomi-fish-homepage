#!/bin/bash

dest="dest/printable"

render_i_o()
{
    local filename="$1"
    shift
    local out_filename="$1"
    shift

    (cd t2 && wml --passoption=2,-X3330 --passoption=3,-I../lib/ \
        -I../lib/ -DROOT~. -DLATEMP_SERVER=t2 -DLATEMP_FILENAME="$filename" \
        -DPRINTABLE=1 "${filename}.wml" $(latemp-config --wml-flags) \
        -DLATEMP_THEME=better-scm \
        -I $HOME/conf/wml/Latemp/lib \
        -I $HOME/apps/wml \
        ) | perl -p -0777 -e 's%\A<\?xml ver[^>]*>%%' \
        > "$dest"/"$out_filename"
}

render()
{
    render_i_o "$1" "$1"
}

mkdir -p "$dest"
render "SFresume_detailed.html"
render "SFresume.html"
render_i_o "me/resumes/Resume-Recent.html" "SFresume-Recent.html"
render_i_o "me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html" "Shlomi-Fish-Resume-as-Software-Dev.html"

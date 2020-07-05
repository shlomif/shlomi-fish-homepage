#!/usr/bin/env bash

set -e

dest="dest/printable"

tt2__render_i_o()
{
    local filename="$1"
    shift
    local out_filename="$1"
    shift

    perl bin/tt-render.pl --printable --stdout --fn="${filename}" \
        | perl -p -0777 -e 's%\A<\?xml ver[^>]*>%%' \
        > "$dest"/"$out_filename"
}
render()
{
    tt2__render_i_o "$1" "$1"
}

mkdir -p "$dest"
render "SFresume_detailed.html"
render "SFresume.html"
tt2__render_i_o "me/resumes/Resume-Recent.html" "SFresume-Recent.html"
tt2__render_i_o "me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html" "Shlomi-Fish-Resume-as-Software-Dev.html"

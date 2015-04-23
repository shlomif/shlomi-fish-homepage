#!/bin/bash
render_i_o()
{
  filename="$1"
  shift
  out_filename="$1"
  shift
  (cd t2 && wml --passoption=2,-X3074 --passoption=3,-I../lib/ \
    -I../lib/ -DROOT~. -DLATEMP_SERVER=t2 -DLATEMP_FILENAME="$filename" \
    -DPRINTABLE=1 "${filename}.wml" $(latemp-config --wml-flags) \
    -DLATEMP_THEME=better-scm \
    -I $HOME/conf/wml/Latemp/lib \
    -I $HOME/apps/wml \
    ) | grep -vP '^<\?xml ver' \
        > printable/"$out_filename"
}

render()
{
    render_i_o "$1" "$1"
}

render "SFresume_detailed.html"
render "SFresume.html"
render_i_o "me/resumes/Resume-Recent.html" "SFresume-Recent.html"

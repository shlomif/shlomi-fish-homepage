" Author: Shlomi Fish
" Date: 10 February 2005
" License: MIT X11
"
" To use: source this file from your .vimrc file, and then type
" <<<
"   :'a,'eRs mypat
" >>>
" to search using the pattern mypat.

function! Range_Search(mypat, start_line, end_line)
    let full_pat = '\%>' . a:start_line . "l" . '\%<' . a:end_line . "l" . a:mypat
    exe '/' . full_pat
    let @/ = full_pat
    norm n
endfunction

command -range -nargs=1 Rs call Range_Search(<f-args>,<line1>,<line2>)
command -range -nargs=1 RS call Range_Search(<f-args>,<line1>,<line2>)


" Author: Shlomi Fish
" Date: 02 December 2006
" License: MIT X11
"
" To use: install Ack ( http://petdance.com/ack/ ), source this script from
" your .vimrc and then type:
"      :Ack [Ack command line args] to use Ack.

function! Ack_Search(command)
    cexpr system("ack " . a:command)
endfunction

command! -nargs=+ -complete=file Ack call Ack_Search(<q-args>)


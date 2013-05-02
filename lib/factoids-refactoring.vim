" e is the english mark
" "f is the fortune buffer
" h is the Hebrew mark.
" a is the common mark.
map <F3> 'e/<li><CR>Vap:s!<\(/\?\)li>!<\1item_en>!g<CR>gv"fd'a"fp}o<ESC>ma
map <F4> <F3>'h/<li><CR>Vap:s!<\(/\?\)li>!<\1item_he>!g<CR>gv"fd'a"fp}o<ESC>ma

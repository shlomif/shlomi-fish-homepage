" e is the english mark
" "f is the fortune buffer
" h is the Hebrew mark.
" a is the common mark.
"
map <S-F3> 'e/<lip\?><CR>Vap:!perl lib/factoids-refactoring.pl en<CR>gv"fd'a"fp}o<ESC>ma
map <F3> mp<S-F3>`p
map <F4> mp<S-F3>'h/<lip\?><CR>Vap:!perl lib/factoids-refactoring.pl he<CR>gv"fd'a"fp}o<ESC>ma`p

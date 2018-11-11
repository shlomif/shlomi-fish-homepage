function! Foo()
    let @e='</'.submatch(1).'_section>'
    return '<'.submatch(1).'_section id="'.submatch(2).'" title="'.submatch(3)."\">"
endfunction

function! Foo_link()
    let @e='</'.submatch(1).'_section>'
    return '<'.submatch(1).'_section id="'.submatch(2).'" href="' .submatch(3). '" title="'.submatch(4)."\">"
endfunction

map <F2> :s!^<\(h[0-9]\) id="\([^"]\+\)">\(.\+\)</\1>$!\=Foo()!<CR><CR>
map <F3> :s!^<\(h[0-9]\) id="\([^"]\+\)"><a href="\([^"]\+\)">\(.\+\)</a></\1>$!\=Foo_link()!<CR><CR>
map <F4> /^<h2_section id="links" title="Links">$/<cr>cc<links_sect><esc>/\/h2_section<cr>cc</links_sect><esc>

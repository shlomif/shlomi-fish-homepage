function! Foo()
    let @e='</'.submatch(1).'_section>'
    return '<'.submatch(1).'_section id="'.submatch(2).'" title="'.submatch(3)."\">"
endfunction

function! Foo_link()
    let @e='</'.submatch(1).'_section>'
    return '<'.submatch(1).'_section id="'.submatch(2).'" href="' .submatch(3). '" title="'.submatch(4)."\">"
endfunction

function! Replace_Sect(myid, title, repl)
    execute ':map <F4> /^<h2_section id="' . a:myid . '" title="' . a:title . '">$/<cr>cc<' . a:repl . '><esc>/\/h2_section<cr>cc</' . a:repl . '><esc>'
    return
endfunction
map <F2> :s!^<\(h[0-9]\) id="\([^"]\+\)">\(.\+\)</\1>$!\=Foo()!<CR><CR>
map <F3> :s!^<\(h[0-9]\) id="\([^"]\+\)"><a href="\([^"]\+\)">\(.\+\)</a></\1>$!\=Foo_link()!<CR><CR>
map <F4> /^<h2_section id="links" title="Links">$/<cr>cc<links_sect><esc>/\/h2_section<cr>cc</links_sect><esc>
map <F4> /^<h2_section id="intro" title="Introduction">$/<cr>cc<intro><esc>/\/h2_section<cr>cc</intro><esc>
call Replace_Sect('about', 'About', 'about_sect')
call Replace_Sect('see_also', 'See Also', 'see_also')

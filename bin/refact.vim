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
call Replace_Sect('news', 'News', 'news_sect')
call Replace_Sect('licence', 'Licence', 'licence_sect')
function H4_repl()
    :%s/<section class="h4">[\s\n]*<h4 id="\([^"]\+\)">\([^<]\+\)<\/h4>\(\_.\{-\}\)<\/section>/<h4_section id="\1" title="\2">\3<\/h4_section>/
    :%s/<section class="h3">[\s\n]*<h3 id="\([^"]\+\)">\([^<]\+\)<\/h3>\(\_.\{-\}\)<\/section>/<h3_section id="\1" title="\2">\3<\/h3_section>/
    :%s/<section class="h2">[\s\n]*<h2 id="\([^"]\+\)">\([^<]\+\)<\/h2>\(\_.\{-\}\)<\/section>/<h2_section id="\1" title="\2">\2<\/h2_section>/
    :%s/\n\n\+//g
endfunction

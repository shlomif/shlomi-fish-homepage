function! Foo()
    let @e='</'.submatch(1).'_section>'
    return '<'.submatch(1).'_section id="'.submatch(2).'" title="'.submatch(3)."\">"
endfunction

function! Foo()
    let @e='[% END %]'
    return '[% WRAPPER '.submatch(1).'_section id="'.submatch(2).'" title="'.submatch(3)."\"%]"
endfunction

function! Foo_link()
    let @e='</'.submatch(1).'_section>'
    return '<'.submatch(1).'_section id="'.submatch(2).'" href="' .submatch(3). '" title="'.submatch(4)."\">"
endfunction

function! Foo_link()
    let @e='[% END %]'
    let ret_ = '[% WRAPPER '.submatch(1).'_section id="'.submatch(2).'" href="' .submatch(3). '" title="'.submatch(4)."\" %]"
    let ret_ = substitute(ret_, "\\v\\[\\% *base_path *\\%\\]", "\${base_path}", "")

    return ret_
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
function! H4_repl()
    :%s/<section class="h4">[\s\n]*<h4 id="\([^"]\+\)">\(\_[^<]\+\)<\/h4>\(\_.\{-\}\)<\/section>/<h4_section id="\1" title="\2">\3<\/h4_section>/
    :%s/<section class="h3">[\s\n]*<h3 id="\([^"]\+\)">\(\_[^<]\+\)<\/h3>\(\_.\{-\}\)<\/section>/<h3_section id="\1" title="\2">\3<\/h3_section>/
    :%s/<section class="h2">[\s\n]*<h2 id="\([^"]\+\)">\(\_[^<]\+\)<\/h2>\(\_.\{-\}\)<\/section>/<h2_section id="\1" title="\2">\3<\/h2_section>/
    :%s/\n\n\+//g
endfunction
function! Deftag()
    :'a,'es/^<define-tag.*/[% IF 0 %]/
    :'a,'es/^<\/define-tag>/[% END %]/
endfunction
function! T2()
    %s#\v\<t2_lect \"([^\"]+)\" *\/\>#[% PROCESS t2_lect url = "\1" %]#g
endfunction
function! Block()
    :'a,'es/^<define-tag \(\([-_]\|\w\)\+\)[^>]*>/[% BLOCK \1 %]/
    :'a,'es/<get-var \(\S\+\) *\/>/[% \1 %]/g
    :'a,'es/^<\/define-tag>/[% END %]/
endfunction
function! V()
    :%s/<get-var \(\S\+\) *\/>/[% \1 %]/g
    :%s#\v\<set\-var +([^\=]+)\=\"([^\"]+)\" *\/ *\>#[% SET \1 = "\2" %]#g
endfunction
function! MyRename()
     !bash bin/rename.bash %
     execute "e " . substitute(expand("%"), "^t2/\\(.*\\)\\.wml$", "src/\\1.tt2", "")
endfunction
command! R call MyRename()
" command! S :s/\v^\#include \"([^\"]+)\"$/[% INCLUDE "\1" %]/
command! S :s/\v^\[\% INCLUDE \"([^\"]+)\" \%\]$/[% path_slurp("\1") %]/
command! -bar D execute("S") | :s/\v\.wml/.tt2/
command! M :s/\v^\<latemp_meta_desc *\"([^\"]+)\" *\/ *\>$/[% SET desc="\1" %]/
command! L :s/\v^\<\: Shlomif\:\:Homepage\:\:LongStories\-\>render_(abstract|common_top_elems|logo)\((\'\w+')\)\; \:\>/[% long_stories__calc_\1(id => \2) %]/
command! -bar S :s!\v^\<h([1-6]) id\=\"([^\"]+)\"\>\<a href\=\"([^\"]+)\"\>([^\<]+)\<\/a\>\<\/h\1\>$![% WRAPPER h\1_section href = "\3" id = "\2" title = "\4" %]! | :s!\v\[\% base_path \%\]!\${base_path}!
command! -bar D :s!\v^\<h([1-6]) id\=\"([^\"]+)\"\>\<a href\=\"\[\% PROCESS rellink url \= \"([^\"]+)\" *\,? *\%\]\"\>([^\<]+)\<\/a\>\<\/h\1\>$![% WRAPPER h\1_section href = "\${base_path}\3" id = "\2" title = "\4" %]! | :s!\v\[\% base_path \%\]!\${base_path}!
command! -bar S2 :s!\v\[\% \"(\$\{base_path\})!\1! | :s!\v\" \%\]\"!"! | :s!\v^\<h([1-6]) id\=\"([^\"]+)\"\>\<a href\=\"([^\"]+)\"\>([^\<]+)\<\/a\>\<\/h\1\>$![% WRAPPER h\1_section href = "\3" id = "\2" title = "\4" %]! | :s!\v\[\% base_path \%\]!\${base_path}!
command! -bar D2 :s!\v^\<h([1-6]) id\=\"([^\"]+)\"\>\<a href\=\"\[\% PROCESS rellink url \= \"([^\"]+)\" *\,? *\%\]\"\>([^\<]+)\<\/a\>\<\/h\1\>$![% WRAPPER h\1_section href = "\${base_path}\3" id = "\2" title = "\4" %]! | :s!\v\[\% base_path \%\]!\${base_path}!
command! H :s!\v^\<h([2-6]) id\=\"([^\"]+)\"\>((\<[^\>]+\><bar>[^\<]+)+)\<\/h\1\>$![% WRAPPER h\1_section id = "\2" title = "\3" %]!
let @s='[% IF 0 %]'
let @e='[% END %]'
let g:tt2end="\n[% END %]\n"
let g:tt2end="\n[% END %]"
let @b='[% main_class.addClass("fancy_sects") %]'
" map <F6> /\v\<get-var \S+ *\/ *\%\]<cr>:s/\v\<get-var (\S+) *\/ *\%\]/\${\1}/<cr>:s/\v\/?\>$/%]/<cr>
map <F6> :S<cr>
map <F6> :H<cr>
map <F7> :S<cr>
map <F4> o<C-r>=g:tt2end<cr><esc>
command! I :%s!\vinkscape(.*)\-\-export\-png!\$(INKSCAPE_WRAPPER)\1--export-type=png --export-file!
command! SM :Ack 'main_class' src/
command! SP :s!\v( id *\= *)(.*)( href *\= *\"[^\"]+\")!\3\1\2!

function! AddIDs()
    %s!\v(<h3)(.*)(/([^\/\"]+)/")!\1 id="\4"\2\3!
endfunction

function! ReplaceAcronym()
    s/my_acronym( *"key" *=> *"\([a-zA-Z_]\+\)" *,\? *)/\1/
endfunction

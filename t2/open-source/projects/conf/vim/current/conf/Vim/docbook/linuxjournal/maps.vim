" maps.vim
"
" Keyboard mappings.


" *********************************************************
" Tag related keys.

call MapTagKey("a", 0, 0, "article", "")
call MapTagKey("b", 0, 0, "emphasis", " role=\"bold\"")
call MapTagKey("c", 0, 0, "command", "")
call MapTagKey("d", 0, 0, "entry", "")
call MapTagKey("e", 0, 0, "email", "")
call MapTagKey("f", 0, 0, "function", "")
call MapTagKey("h", 1, 0, "title", "")
call MapTagKey("i", 0, 0, "emphasis", "")
"               j - extension key below.
call MapTagKey("k", 0, 0, "command", " role=\"what-to-type\"")
call MapTagKey("l", 0, 0, "listitem", "")
call MapTagKey("m", 1, 0, "mediaobject", "")
call MapTagKey("n", 1, 0, "itemizedlist", "")
call MapTagKey("o", 1, 0, "orderedlist", "")
call MapTagKey("p", 1, 1, "para", "")
call MapTagKey("q", 0, 0, "quote", "")
call MapTagKey("r", 1, 1, "row", "")
call MapTagKey("s", 1, 1, "sidebar", "")
call MapTagKey("t", 1, 1, "table", "")
call MapTagKey("u", 0, 0, "ulink", "")
"               x - extension key below.

call MapTagKey("jd", 0, 0, "remark", " role=\"web-pub-date\"")
call MapTagKey("ji", 0, 0, "remark", " role=\"author-image\"")
call MapTagKey("jl", 0, 0, "remark", " role=\"layout-info\"")
call MapTagKey("jn", 0, 0, "remark", " role=\"article-number\"")
call MapTagKey("jo", 0, 0, "remark", " role=\"output-file\"")
call MapTagKey("jp", 0, 0, "remark", " role=\"pull-quote\"")
call MapTagKey("js", 0, 0, "remark", " role=\"article-section\"")
call MapTagKey("jt", 0, 0, "remark", " role=\"teaser\"")
call MapTagKey("jw", 0, 0, "remark", " role=\"article-series\"")

call MapTagKey("xa", 0, 0, "author", "")
call MapTagKey("xb", 1, 0, "blockquote", "")
call MapTagKey("xc", 1, 1, "CDATA", "")
call MapTagKey("xf", 0, 0, "firstname", "")
call MapTagKey("xi", 0, 0, "articleinfo", "")
call MapTagKey("xl", 0, 0, "surname", "")
call MapTagKey("xm", 0, 0, "othername", " role=\"middle\"")
call MapTagKey("xn", 1, 1, "COMMENT", "")
call MapTagKey("xo", 1, 1, "screen", "")
call MapTagKey("xp", 1, 1, "programlisting", "")
call MapTagKey("xq", 1, 0, "question", "")
call MapTagKey("xr", 1, 0, "answer", "")
call MapTagKey("xs", 1, 1, "simplesect", "")


" *********************************************************
" Insert special symbols.

call MapSymbolKey("3", "&frac34;")
call MapSymbolKey("5", "&lsquo;")
call MapSymbolKey("6", "&rsquo;")
call MapSymbolKey("7", "&ldquo;")
call MapSymbolKey("8", "&rdquo;")
call MapSymbolKey(",", "&lt;")
call MapSymbolKey(".", "&gt;")
call MapSymbolKey("<", "&lt;")
call MapSymbolKey(">", "&gt;")
call MapSymbolKey("a", "&aelig;")
call MapSymbolKey("c", "&copy;")
call MapSymbolKey("d", "&deg;")
call MapSymbolKey("f", "&frac14;")
call MapSymbolKey("h", "&half;")
call MapSymbolKey("n", "&ndash;")
call MapSymbolKey("m", "&mdash;")
call MapSymbolKey("r", "&reg;")
call MapSymbolKey("t", "&times;")

call MapSymbolKey("_", "\<Esc>!!date<CR>")

" nmap _  o<Esc>!!date

" *********************************************************
" Insert foreign characters.

call MapForeignCharKey("b",   "&beta;")
call MapForeignCharKey("m",   "&mu;")
call MapForeignCharKey("n",   "ñ")
call MapForeignCharKey("w",   "&ohgr;")

call MapForeignCharKey("'a",  "á")
call MapForeignCharKey("'c",  "ç")
call MapForeignCharKey("'e",  "é")
call MapForeignCharKey("'i",  "í")
call MapForeignCharKey("'o",  "ó")
call MapForeignCharKey("'u",  "ú")

call MapForeignCharKey("`a",  "à")
call MapForeignCharKey("`e",  "è")
call MapForeignCharKey("`i",  "ì")
call MapForeignCharKey("`o",  "ò")
call MapForeignCharKey("`u",  "ù")

call MapForeignCharKey("\"a", "ä")
call MapForeignCharKey("\"e", "ë")
call MapForeignCharKey("\"i", "ï")
call MapForeignCharKey("\"o", "ö")
call MapForeignCharKey("\"u", "ü")

call MapForeignCharKey("^a",  "â")
call MapForeignCharKey("^e",  "ê")
call MapForeignCharKey("^i",  "î")
call MapForeignCharKey("^o",  "ô")
call MapForeignCharKey("^u",  "û")


" *********************************************************
" Moving and adjusting tags.

nmap <S-F8> :call DeleteTag()				" Delete tag at cursor.

nmap <F9> :call CursorLeftByTag()			" Move left by tags.
nmap <F10> :call MoveTagLeft()			" Move tag left of preceding word.
nmap <F11> :call MoveTagRight()			" Move tag right of following word.
nmap <F12> :call CursorRightByTag()			" Move right by tags.

nmap <S-F9> :call TightenTagLeft()			" Delete whitespace left of tag.
nmap <S-F10> :call InsertStringLeftOfTag(" ")		" Insert space to the left of tag.
nmap <S-F11> :call InsertStringRightOfTag(" ")	" Insert space to the right of tag.
nmap <S-F12> :call TightenTagRight()			" Delete whitespace right of tag.


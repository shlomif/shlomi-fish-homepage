function! Add_isbn_tag()
    let url = getreg("*")
    let asin = matchlist(url, "dp/\\(\\w\\+\\)/")[1]
    execute "normal " . "o<isbn>" . asin . "</isbn>"
endfunction

map <F4> :call Add_isbn_tag()<CR>


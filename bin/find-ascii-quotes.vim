function! Find_next()
    while (search("[\"']", 'W') != 0)
        if (synID(line("."), col("."), 1) == 0)
            return
        endif
    endwhile
endfunction

map <F2> :call Find_next()<CR>

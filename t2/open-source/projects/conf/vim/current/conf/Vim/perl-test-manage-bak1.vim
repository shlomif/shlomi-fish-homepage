function! Perl_Tests_Count()
    " Position the cursor at the beginning of the file
    call cursor(1,1)
    " Count the number of lines which indicate a test
    let mycount = 0
    while (search("# \\+TEST", "W") > 0)
        let mycount = mycount + 1
    endwhile
    call cursor(1,1)
    call search("^use \\(Test::More\\|CondTestMore\\)","W")
    let line_contents = getline(line("."))
    let new_line_contents = substitute(line_contents, "\\d\\+", mycount, "")
    call setline(".", new_line_contents)
    " call setline(".", mycount)
endfunction


" perl-test-manage.vim - keeps track of the number of tests in a Perl test
" file (t/*.t) by counting '# TEST' comments.
"
" In order to keep track of the number of tests you need to have a statement
" like:
"
"     use Test::More tests => 20
"
" at the beginning of the test file. Then you need to make sure, every test
" has a corresponding '# TEST' comment. If you run several tests in a loop,
" you can append asterisks plus number to the comment. So for example the
" comment:
"
"     # TEST*3*5
"
" will add 15 tests to the test number.
"
" To use this file place it on your file-system, include it (at least for
" perl test files) and optionally bind a key to call Perl_Tests_Count(). I
" have the following in my .vimrc file, for that:
"
" autocmd BufNewFile,BufRead *.t so ~/conf/Vim/perl-test-manage.vim
" autocmd BufNewFile,BufRead *.t map <F3> :call Perl_Tests_Count()<CR>
"
" Author: Shlomi Fish
" Date: 02 December 2004
" License: MIT X11
"

function! Perl_Tests_Count()
    " Position the cursor at the beginning of the file
    call cursor(1,1)
    " Count the number of lines which indicate a test
    let mycount = 0
    while search("# \\+TEST", "W") > 0
        let num_tests_to_add = 1
        let line_contents = getline(line("."))
        let multipliers = substitute(line_contents, "^.*# \\+TEST", "", "")
        let star_m = matchstr(multipliers, "^\\*\\d\\+")
        while star_m != ""
            let multipliers = substitute(multipliers, "^\\*\\d\\+", "", "")
            let mult = substitute(star_m, "^\\*", "", "")
            let num_tests_to_add = num_tests_to_add * mult
            let star_m = matchstr(multipliers, "^\\*\\d\\+")
        endwhile

        let mycount = mycount + num_tests_to_add
    endwhile
    call cursor(1,1)
    call search("^use \\(Test::More\\|CondTestMore\\)","W")
    let line_contents = getline(line("."))
    let new_line_contents = substitute(line_contents, "\\d\\+", mycount, "")
    call setline(".", new_line_contents)
    " call setline(".", mycount)
endfunction


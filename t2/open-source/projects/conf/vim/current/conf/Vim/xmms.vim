function Xmms_Play_Mp3(prog, xmms_opts)
    let line = getline(".")
    let repl = substitute(line, "'", "'\\\\''", "ge")
    let repl = substitute(repl, "!", "\\\\!", "g")
    execute "silent !" . a:prog . " " . a:xmms_opts . " '" . repl . "'"
endfunction

map <F3> :call Xmms_Play_Mp3("xmms", "-e")<CR>
map <S-F3> :call Xmms_Play_Mp3("xmms", "")<CR>

map <F4> :call Xmms_Play_Mp3("/home/shlomi/apps/sound/bmpx/bin/bmp-enqueue-files-2.0", "")<CR><CR>
map <S-F4> :call Xmms_Play_Mp3("/home/shlomi/apps/sound/bmpx/bin/bmp-play-files-2.0", "")<CR><CR>


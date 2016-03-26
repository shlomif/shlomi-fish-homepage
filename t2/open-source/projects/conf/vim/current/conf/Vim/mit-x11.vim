function! Add_MIT_X_License()
    normal G
    read ~/conf/Vim/texts/mit-x11-perl.pod
    normal G
endfunction

command! AddX11License :call Add_MIT_X_License()

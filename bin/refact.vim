map <F2> :s!^<\(h[0-9]\) id="\([^"]\+\)">\([^<]\+\)</\1>$!<\1_section id="\2" title="\3">\r\r</\1_section>\r\r!<CR>

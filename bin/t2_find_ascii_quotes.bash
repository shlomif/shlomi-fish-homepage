#!/bin/bash
find dest/t2-homepage/ -regextype posix-extended -regex '.*x?html' -print | sort | grep -vP '(catb-heb|WebMetaLecture/slides/examples|t2-homepage/rewrite\.html|humour/by-others/|humour/bits/COBOL-the-New-Age|humour/bits/Mastering-Cat|humour/fortunes/nyh-sigs)' | xargs -d '\n' perl bin/find_ascii_quotes-xmlp.pl > results.txt

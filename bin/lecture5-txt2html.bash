#!/bin/bash
txt2html --xhtml --eight_bit_clean --title "Perl for Newbies Lecture 5: Hebrew Notes" t2/lecture/Perl/Newbies/lecture5-notes.txt |
(while read l ; do
    echo "$l"
    if echo "$l" | grep '^<meta name=' > /dev/null ; then
        cat <<'EOF'
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
body { direction: rtl; text-align: right; }
</style>
EOF
    fi
done
)

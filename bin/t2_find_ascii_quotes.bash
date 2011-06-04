#!/bin/bash

# This is a temporary filter until I find out how to get rid of them there
# exactly.
temp_filter()
{
    grep -vP '(humour/human-hacking/hebrew-v2|humour/humanity/buy-the-fish-in-hebrew|humour/humanity/ongoing-text-hebrew\.html|humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text)'
}

find dest/t2-homepage/ -regextype posix-extended -regex '.*x?html' -print | 
    sort | 
    grep -vP '(catb-heb|WebMetaLecture/slides/examples|t2-homepage/rewrite\.html|humour/by-others/|humour/bits/COBOL-the-New-Age|humour/bits/Mastering-Cat|humour/fortunes/nyh-sigs|humour/fortunes/sharp-perl|humour/fortunes/sharp-programming|humour/fortunes/|humour/human-hacking/arabic-v2|humour/human-hacking/human-hacking-field-guide/|humour/human-hacking/human-hacking-field-guide-v2-arabic/)' | 
    temp_filter |
    xargs -d '\n' perl bin/find_ascii_quotes-xmlp.pl > results.txt

#!/bin/bash

# This is a temporary filter until I find out how to get rid of them there
# exactly.
temp_filter()
{
    grep -vP '(humour/human-hacking/hebrew-v2|humour/humanity/buy-the-fish-in-hebrew|humour/humanity/ongoing-text-hebrew\.html|humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text)' |
    grep -vP '^(dest/t2-homepage/index\.html)' |
    grep -vP '^(dest/t2-homepage/old-news\.html)' |
    grep -vP '^(dest/t2-homepage/lecture/)'
}

temp_only_from_reached()
{
    perl -lne 'print if m{t2-homepage/open-source}..1'
}

find dest/t2-homepage/ -regextype posix-extended -regex '.*x?html' -print | 
    sort | 
    temp_only_from_reached |
    grep -vP '(catb-heb|WebMetaLecture/slides/examples|t2-homepage/rewrite\.html|humour/by-others/|humour/bits/COBOL-the-New-Age|humour/bits/Mastering-Cat|humour/fortunes/nyh-sigs|humour/fortunes/sharp-perl|humour/fortunes/sharp-programming|humour/fortunes/|humour/human-hacking/arabic-v2|humour/human-hacking/human-hacking-field-guide/|humour/human-hacking/human-hacking-field-guide-v2-arabic/|humour/TheEnemy/TheEnemy_eng\.html|humour/TheEnemy/The-Enemy-English-rev4\.html|humour/TheEnemy/The-Enemy-English-rev5\.html|humour/TheEnemy/The-Enemy-English-rev6\.html|humour/TheEnemy/The-Enemy-English-v7/|humour/TheEnemy/The-Enemy-Hebrew-v7\.html|humour/TheEnemy/The-Enemy-English-v7\.html|humour/TheEnemy/TheEnemy\.html|humour/TheEnemy/The-Enemy-rev[456]\.html|me/resumes/Shlomi-Fish-Heb-Resume\.html)' | 
    temp_filter |
    grep -vP 'meta/copyrights/index\.html' | # Contains rel="nofollow"
    grep -vP 'open-source/anti/php/index\.html' | # Contains code
    grep -vP 'open-source/bits-and-bobs/greasemonkey/grease\.html' | # Contains HTML markup
    xargs -d '\n' perl bin/find_ascii_quotes-xmlp.pl > results.txt

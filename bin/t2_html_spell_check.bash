#!/bin/bash

# This is a temporary filter until I find out how to get rid of them there
# exactly.
temp_filter()
{
    grep -vE '(humour/human-hacking/hebrew-v2|humour/humanity/buy-the-fish-in-hebrew|humour/humanity/ongoing-text-hebrew\.html|humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text)' |
    grep -vE '^(dest/t2-homepage/index\.html)' |
    grep -vE '^(dest/t2-homepage/old-news\.html)' |
    grep -vE '^(dest/t2-homepage/lecture/)' |
    grep -vE '^(dest/t2-homepage/philosophy/politics/define-zionism/heb/index\.html)' |
    grep -vE '^(dest/t2-homepage/philosophy/politics/drug-legalisation/hebrew\.html)'
    cat
}

temp_only_from_reached()
{
    perl -lne 'print if m{t2-homepage/prog-evolution}..1'
}

old_find_quotes_filter()
{
    grep -vE '(catb-heb|WebMetaLecture/slides/examples|t2-homepage/rewrite\.html|humour/by-others/|humour/bits/COBOL-the-New-Age|humour/bits/Mastering-Cat|humour/fortunes/nyh-sigs|humour/fortunes/sharp-perl|humour/fortunes/sharp-programming|humour/fortunes/|humour/human-hacking/arabic-v2|humour/human-hacking/human-hacking-field-guide/|humour/human-hacking/human-hacking-field-guide-v2-arabic/|humour/TheEnemy/TheEnemy_eng\.html|humour/TheEnemy/The-Enemy-English-rev4\.html|humour/TheEnemy/The-Enemy-English-rev5\.html|humour/TheEnemy/The-Enemy-English-rev6\.html|humour/TheEnemy/The-Enemy-English-v7/|humour/TheEnemy/The-Enemy-Hebrew-v7\.html|humour/TheEnemy/The-Enemy-English-v7\.html|humour/TheEnemy/TheEnemy\.html|humour/TheEnemy/The-Enemy-rev[456]\.html|me/resumes/Shlomi-Fish-Heb-Resume\.html)' |
    grep -vE 'meta/copyrights/index\.html' | # Contains rel="nofollow"
    grep -vE 'open-source/anti/php/index\.html' | # Contains code
    grep -vE 'open-source/bits-and-bobs/greasemonkey/grease\.html' | # Contains HTML markup
    grep -vE 'open-source/projects/Module-Format/index\.html' | # contains code
    grep -vE 'open-source/projects/XML-Grammar/Fiction/index\.html' | # contains markup
    grep -vE 'open-source/projects/Spark/mission/' | # contains code
    grep -vE 'philosophy/by-others/mashhoor--10-reasons--hebrew\.html' | # contains code
    grep -vE 'philosophy/computers/high-quality-software/index\.html$' | # old essay
    grep -vE 'philosophy/computers/high-quality-software/rev2/index\.html$' | # contains output
    grep -vE 'philosophy/computers/high-quality-software/rev2/what-makes-software-high-quality-rev2/freecell-solvers-quality\.html$' | # contains output
    grep -vE 'philosophy/computers/high-quality-software/rev2/what-makes-software-high-quality-rev2/parameters-of-quality\.html$' | # contains output
    grep -vE 'philosophy/computers/high-quality-software/what-makes-software-high-quality/' | # old
    grep -vE 'philosophy/computers/optimizing-code-for-speed/index\.html$' | # old
    grep -vE 'philosophy/computers/perl/joy-of-perl/joy-of-perl\.html$' | # contains some code
    grep -vE 'philosophy/computers/software-management/perfect-workplace/perfect-it-workplace(/|\.xhtml$)' | # old
    grep -vE 'philosophy/computers/web/create-a-great-personal-homesite/index\.html' | # in code
    grep -vE 'philosophy/computers/web/create-a-great-personal-homesite/rev2\.html' | # in code
    grep -vE 'philosophy/computers/web/online-communities/index\.html' | # in code
    grep -vE 'philosophy/foss-other-beasts/revision-2/' | # in code
    grep -vE 'philosophy/obj-oss/objectivism-and-open-source/' | # old
    grep -vE 'philosophy/politics/drug-legalisation/case-for-drug-legalisation/' | # old
    grep -vE 'rindolf/rindolf-spec/' # old and contains code
}

find dest/t2-homepage/ -regextype posix-extended -regex '.*x?html' -print |
    grep -vE '/catb-heb\.html$' | # HTML - not XHTML file.
    grep -vE 'WebMetaLecture/slides/examples' | # HTML - not XHTML files.
    grep -vE '/rewrite\.html$' | # HTML - not XHTML files.
    sort |
    xargs -d '\n' perl bin/html-check-spelling-xmlp.pl

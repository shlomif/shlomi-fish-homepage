#!/bin/bash
find src -name '*.tt2' | (LC_ALL=C sort) | \
    xargs grep -L 'SET desc' | \
    grep -vP '^t2/(?:work/hire-me/hebrew\.|work/hire-me/index\.html|personal-heb\.|personal\.|SFresume|humour\.|humour-heb\.|lecture/Perl/Newbies/lecture5-heb-notes|me/resumes/Shlomi-Fish-Heb-Resume)'

#!/bin/bash
find t2 -name '*.wml' | (LC_ALL=C sort) | \
    xargs grep -L latemp_meta_desc | \
    grep -vP '^t2/(?:personal-heb\.|personal\.|SFresume|humour\.|humour-heb\.|lecture/Perl/Newbies/lecture5-heb-notes|me/resumes/Shlomi-Fish-Heb-Resume)'

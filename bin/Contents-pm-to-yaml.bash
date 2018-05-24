#! /bin/bash
#
# Contents-pm.bash
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#


l1()
{
git ls-files lib/presentations/qp | grep -P 'Contents\.pm$'
}

l1 | (while read t
do
    (cd `dirname "$t"` && perl -I. -E 'use Contents; use YAML::XS qw/ DumpFile /; DumpFile("Contents.yml", Contents::get_contents());' && git add Contents.yml)
done)

#!/bin/sh
perl -MFile::Find -e 'sub mypush { push @f, $File::Find::name if (/\.wml$/) } find(\&mypush, "t2"); print join(" ", @f);'

#!/bin/sh
perl -MFile::Find -e 'sub mypush { push @f, $File::Find::name if (/\.html\.wml$/) } find(\&mypush, $ARGV[0]); print join(" ", @f);' "$1"

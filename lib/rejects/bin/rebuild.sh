#! /bin/sh
#
# rebuild.sh
# Copyright (C) 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
no_longer_needed_due_to_avoiding_recursive_make=false
if $no_longer_needed_due_to_avoiding_recursive_make
then
    cl_d=../"$(basename "$PWD")"--clones
    mkdir -p "$cl_d"
    for d in "$cl_d"/*
    do
        if test -e "$d"
        then
            ( cd "$d"; time git clean -dfqx . )
        fi
    done
fi

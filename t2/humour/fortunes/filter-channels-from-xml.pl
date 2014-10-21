#!/usr/bin/perl

use strict;
use warnings;

my @this_fort;

while (<>)
{
    if (/\A *<fortune/)
    {
        @this_fort = ($_);
        GET_FORT_LOOP:
        while (<>)
        {
            if (m{\A *</fortune})
            {
                last GET_FORT_LOOP;
            }
            push @this_fort, $_;
        }
        push @this_fort, $_;

        my $entire_fort = join("", @this_fort);

        if (! (($entire_fort =~ m{<channel>\#\#programming</channel>})
            &&
            ($entire_fort =~ m{<network>Freenode</network>}i)
        ))
        {
            print @this_fort;
        }
    }
    else
    {
        print;
    }
}



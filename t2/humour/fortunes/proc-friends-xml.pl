#!/usr/bin/perl

use strict;
use warnings;

my $count = 1;
my $enc = 0;
my $id_str = "PLOC-IDENT";
my $title_str = "QUACKPROLOKOG==UNKNOWN-TITLE";

while (<>)
{
    if (m{\A   *<fortune id="\Q$id_str\E\Q$count\E">}ms)
    {
        s{\Q$id_str\E}{friends-tv-excerpt-};
    }
    elsif (m{\A  *<title>\Q$title_str\E</title>}ms)
    {
        s{\Q$title_str\E}{Excerpt from the TV Show "Friends" - #$count};
        $count++;
    }
}
continue
{
    print;
}

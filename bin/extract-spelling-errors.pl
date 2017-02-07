#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use utf8;

binmode STDOUT, ":encoding(UTF-8)";

open my $i, '<:encoding(UTF-8)', 'foo.txt';
while ( my $l = <$i> )
{
    foreach my $m ( $l =~ m/«(.*?)»/g )
    {
        print "$m\n";
    }
}
close($i);

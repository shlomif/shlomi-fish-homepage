#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use utf8;

binmode STDOUT, ":encoding(UTF-8)";

open my $i, '<:encoding(UTF-8)', 'foo.txt';
my %h;
my @matches;
while ( my $l = <$i> )
{
    foreach my $m ( $l =~ m/«(.*?)»/g )
    {
        if ( !$h{$m}++ )
        {
            push @matches, $m;
        }
    }
}
close($i);
foreach my $m (@matches)
{
    print "$m\t$h{$m}\n";
}

#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use utf8;

binmode STDOUT, ":utf8";

open my $i, '<:utf8', 'foo.txt';
while (my $l = <$i>)
{
    foreach my $m ($l =~ m/«(.*?)»/g)
    {
        print "$m\n";
    }
}
close($i);

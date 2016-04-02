#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

STDOUT->autoflush(1);
my $NUM_LAST = 100;
my @last;
my $STATUS_EVERY = 200;
my $count = 0;
while (my $l = <STDIN>)
{
    push @last, $l;
    if (@last > $NUM_LAST)
    {
        shift @last;
    }
    if (((++$count) % $STATUS_EVERY) == 0)
    {
        print "Reached $count\n";
    }
}
print @last;

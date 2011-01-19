#!/usr/bin/perl

use strict;
use warnings;

open my $in, "/sbin/ifconfig |";

my (@addrs);

while (my $line = <$in>)
{
    if ($line =~ /inet addr:((\d+\.)+\d)/)
    {
        push @addrs, $1;
    }
}
close($in);

print "You have the following addresses: \n", join("\n",@addrs), "\n";

#!/usr/bin/perl

use strict;
use warnings;

open I, "/sbin/ifconfig |";
my ($line, @addrs);
while ($line = <I>)
{
    if ($line =~ /inet addr:((\d+\.)+\d)/)
    {
        push @addrs, $1;
    }
}
close(I);
print "You have the following addresses: \n", join("\n",@addrs), "\n";

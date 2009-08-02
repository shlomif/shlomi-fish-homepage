#!/usr/bin/perl

use strict;
use warnings;

my $dir = shift;
# Prepare $dir for placement inside a '...' argument
$dir =~ s!'!'\\''!g;

my $count = `ls -l '$dir' | grep ^d | wc -l`;

$count =~ /(\d+)/;
# Retrieve the number via the special regex variable $1
$count = $1;

print "There are $count directories\n";

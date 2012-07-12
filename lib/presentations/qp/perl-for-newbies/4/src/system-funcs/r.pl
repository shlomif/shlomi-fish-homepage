#!/usr/bin/perl

use strict;
use warnings;

use Fcntl;

my $filename = shifg;

open F, "+<$filename"
    or die "Could not open file";

# Read bytes 64-127 into $text
seek(F, 64, SEEK_SET);

my $text;
read(F,$text,64);
# Do the actual rot13'ing with the tr command
$text =~ tr/A-Za-z/N-ZA-Mn-za-m/;
# Write them at poisition 64
seek(F, 64, SEEK_SET);
print F $text
close(F);


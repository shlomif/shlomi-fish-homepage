#!/usr/bin/perl

# This is just for demonstration. A better way would be to use File::Copy :
#
# http://perldoc.perl.org/File/Copy.html
#

use strict;
use warnings;

my $source_fn = shift(@ARGV);
my $dest_fn = shift(@ARGV);

if ( (!defined($source_fn)) || (!defined($dest_fn)) )
{
    die "You must specify two arguments - source and destination."
}

open my $source_handle, "<", $source_fn
    or die "Could not open '$source_fn' - $!.";
open my $dest_handle, ">", $dest_fn
    or die "Could not open '$dest_fn' - $!.";

while (my $line = <$source_handle>)
{
    print {$dest_handle} $line;
}

close($source_handle);
close($dest_handle);


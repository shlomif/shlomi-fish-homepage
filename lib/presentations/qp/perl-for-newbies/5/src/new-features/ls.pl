#!/usr/bin/perl

use strict;
use warnings;

sub get_entries
{
    my $dir_path = shift;

    opendir my $dir_handle, $dir_path
        or die "Cannot open '$dir_path' as a directory - $!.";

    my @entries = readdir($dir_handle);

    closedir($dir_handle);

    return [ sort { $a cmp $b } @entries ];
}

foreach my $arg (@ARGV)
{
    print "== Listing for $arg ==\n";
    foreach my $entry (@{get_entries($arg)})
    {
        print $entry, "\n";
    }
}

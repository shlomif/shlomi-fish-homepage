#!/usr/bin/perl

use strict;
use warnings;


sub get_dir_files
{
    my $dir_path = shift;

    opendir D, $dir_path
        or die "Cannot open the directory $dir_path";

    my @entries;
    @entries = readdir(D);
    closedir(D);

    return \@entries;
}

my $dir_path = shift || ".";

my $entries = get_dir_files($dir_path);
my @mp3s = (grep { /\.mp3$/ } @$entries);

print "You have " . scalar(@mp3s) . " mp3s in $dir_path.\n";


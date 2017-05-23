#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my $date = "2008-10-20";

my $remove_at = qq{remove_at="$date"};

foreach my $file (`ack -l '$remove_at' t2`)
{
    chomp($file);
    print $file, "\n";
    path($file)->edit_utf8(
        sub {
s{(?:^;;;[^\n]*\n)*<shlomif_sponsored_ad[^\n]*\Q$remove_at\E.*?</shlomif_sponsored_ad>[^\n]*\n?}{}ms;
        }
    );
}


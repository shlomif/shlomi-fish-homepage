#!/usr/bin/env perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my $date = '2008-10-20';

my $remove_at = qq{remove_at="$date"};

foreach my $fn (`ack -l '$remove_at' t2`)
{
    chomp($fn);
    print $fn, "\n";
    path($fn)->edit_utf8(
        sub {
s{(?:^;;;[^\n]*\n)*<shlomif_sponsored_ad[^\n]*\Q$remove_at\E.*?</shlomif_sponsored_ad>[^\n]*\n?}{}ms;
        }
    );
}

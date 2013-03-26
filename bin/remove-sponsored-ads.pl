#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my $date = "2008-10-20";

my $remove_at = qq{remove_at="$date"};

foreach my $file (`ack -l '$remove_at' t2`)
{
    chomp($file);
    print $file, "\n";
    my $text = io($file)->slurp();
    $text =~ s{(?:^;;;[^\n]*\n)*<shlomif_sponsored_ad[^\n]*\Q$remove_at\E.*?</shlomif_sponsored_ad>[^\n]*\n?}{}ms;
    io($file)->print($text);
}


#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

{
    open my $ack_fh, '-|', 'ack', '-l', q/[ \t]+$/, '.'
        or die "Cannot open ack for input - $!";

    my $count_lines = 0;
    while (my $l = <$ack_fh>)
    {
        $count_lines++;
        diag($l);
    }

    # TEST
    is ($count_lines, 0, "Count lines is 0.");

    close($ack_fh);
}

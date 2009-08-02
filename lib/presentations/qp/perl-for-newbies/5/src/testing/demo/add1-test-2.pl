#!/usr/bin/perl

use strict;
use warnings;

use Add1 (qw(add));

if (!(add(2,2) == 4))
{
    die "add(2,2) failed";
}

{
    my $result = add(1,1);

    if ($result != 2)
    {
        die "add(1,1) resulted in '$result' instead of 2."
    }
}

exit(0);

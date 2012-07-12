#!/usr/bin/perl

use strict;
use warnings;

use Add1 (qw(add));

if (!(add(2,2) == 4))
{
    die "add(2,2) failed";
}
exit(0);

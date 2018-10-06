#!/usr/bin/env perl

use strict;
use warnings;

my $re = qr#(?:saying|para|description|inlinedesc)#;

while ( my $l = <> )
{
    print +( $l =~ s#(<${re}[^>]*>)#\n$1\n#gr =~ s#(</${re}>)#\n$1\n#gr =~
            s#[ \t]+$##gmsr );
}

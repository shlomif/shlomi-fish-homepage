package Shlomif::Age;

use strict;
use warnings;

use DateTime ();

sub calc_age
{
    my ($class) = @_;

    my $birth = DateTime->new( year => 1977, month => 5, day => 5 );

    my $now = DateTime->now();

    return ( $now - $birth )->years();
}

1;

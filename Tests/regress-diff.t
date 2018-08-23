use strict;
use warnings;

use Test::More ( tests => 1 );
use Test::Differences qw(eq_or_diff);

my $src  = 'post-dest';
my $good = '../GOOD-post-dest';

{
    # TEST
    if ( -d $good )
    {
        eq_or_diff( scalar(`diff -u -r $src $good | head --bytes=300`),
            '', "Empty diff.", );
    }
    else
    {
        ok( 1, "No $good" );
    }
}

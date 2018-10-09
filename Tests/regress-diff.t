use strict;
use warnings;

use Test::More ( tests => 1 );
use Test::Differences qw(eq_or_diff);

use lib './lib';
use HTML::Latemp::Local::Paths ();

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

my $src = $T2_POST_DEST;

my $good = '../GOOD-post-inc/t2';

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

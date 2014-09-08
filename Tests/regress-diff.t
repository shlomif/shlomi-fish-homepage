use strict;
use warnings;

use Test::More (tests => 1);
use Test::Differences qw(eq_or_diff);

my $src = 'dest';
my $good = '../GOOD-dest';

{
    # TEST
    if (-d $good)
    {
        eq_or_diff(
            scalar(`diff -u -r $src $good | head -10`),
            '',
            "Empty diff.",
        );
    }
    else
    {
        ok (1, "No $good");
    }
}

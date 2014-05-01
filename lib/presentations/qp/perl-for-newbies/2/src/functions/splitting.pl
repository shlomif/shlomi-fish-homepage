use strict;
use warnings;

sub mysplit
{
    my ($total, $num_elems, @accum) = @_;

    if ($num_elems == 1)
    {
        push @accum, $total;
        print join(",", @accum), "\n";

        return;
    }

    for (my $item=0 ; $item <= $total ; $item++)
    {
        my @new_accum = (@accum, $item);
        mysplit($total-$item, $num_elems-1, @new_accum);
    }
}

mysplit(10,3);


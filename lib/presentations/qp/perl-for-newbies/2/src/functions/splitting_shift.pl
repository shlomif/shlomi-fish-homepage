use strict;
use warnings;

sub mysplit
{
    my $total = shift;
    my $num_elems = shift;
    my @accum = @_;
    my (@ret, @new_accum);


    if ($num_elems == 1)
    {
        push @accum, $total;
        print join(",", @accum), "\n";

        return;
    }

    for(my $a=0;$a<=$total;$a++)
    {
        @new_accum = (@accum, $a);
        mysplit($total-$a, $num_elems-1, @new_accum);
    }
}

mysplit(10,3);



use strict;
use warnings;

sub vector_sum
{
    my $v1_ref = shift;
    my $v2_ref = shift;

    my @ret;

    my @v1 = @{$v1_ref};
    my @v2 = @{$v2_ref};

    if (scalar(@v1) != scalar(@v2))
    {
        return undef;
    }
    for(my $i=0;$i<scalar(@v1);$i++)
    {
        push @ret, ($v1[$i] + $v2[$i]);
    }

    return [ @ret ];
}

my $ret = vector_sum(
    [ 5, 9, 24, 30 ],
    [ 8, 2, 10, 20 ]
);

print join(", ", @{$ret}), "\n";

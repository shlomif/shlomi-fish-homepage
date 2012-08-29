#!/usr/bin/perl -w

use strict;

# use Memoize;

# This function gets the squaring factors of $n.
# The squaring factors are those prime numbers that need to be multiplied
# by $n to reach a perfect square. They are the minimal such number.

my %gsf_cache = (1 => []);

sub get_squaring_factors
{
    my $n = shift;

    if (exists($gsf_cache{$n}))
    {
        return $gsf_cache{$n};
    }

    my $start_from = shift || 2;

    for(my $p=$start_from; ;$p++)
    {
        if ($n % $p == 0)
        {
            # This function is recursive to make better use of the Memoization
            # feature.
            my $division_factors = get_squaring_factors(($n / $p), $p);
            if (@$division_factors && ($division_factors->[0] == $p))
            {
                return ($gsf_cache{$n} = [ @{$division_factors}[1 .. $#$division_factors] ]);
            }
            else
            {
                return ($gsf_cache{$n} = [ $p, @$division_factors ]);
            }
        }
    }
}

# memoize('get_squaring_factors', 'NORMALIZER' => sub { return $_[0]; });

# This function multiplies the squaring factors of $n and $m to receive
# the squaring factors of ($n*$m)


sub multiply_squaring_factors
{
    my $n_ref = shift;
    my $m_ref = shift;

    my @n = @$n_ref;
    my @m = @$m_ref;

    my @ret = ();

    while (scalar(@n) && scalar(@m))
    {
        if ($n[0] == $m[0])
        {
            shift(@n);
            shift(@m);
        }
        elsif ($n[0] < $m[0])
        {
            push @ret, shift(@n);
        }
        else
        {
            push @ret, shift(@m);
        }
    }
    push @ret, @n, @m;
    return \@ret;
}

sub Graham
{
    my $n = shift;

    my $n_sq_factors = get_squaring_factors($n);

    # The graham number of a perfect square is itself.
    if (scalar(@$n_sq_factors) == 0)
    {
        return ($n, [$n]);
    }

    # Cheating: 
    # Check if between n and n+largest_factor we can fit
    # a square of SqFact{n*(n+largest_factor)}. If so, return
    # n+largest_factor.
    #
    # So, for instance, if n = p than n+largest_factor = 2p
    # and so SqFact{p*(2p)} = 2 and it is possible to see if
    # there's a 2*i^2 between p and 2p. That way, p*2*i^2*2p is
    # a square number.

    {
        my $largest_factor = $n_sq_factors->[$#$n_sq_factors];

        my ($lower_bound, $lb_sq_factors);
        
        $lower_bound = $n + $largest_factor;
        while (1)
        {
            $lb_sq_factors = get_squaring_factors($lower_bound);
            if (grep { $_ == $largest_factor } @$lb_sq_factors)
            {
                last;
            }
            $lower_bound += $largest_factor;
        }

        my $n_times_lb = 
            multiply_squaring_factors($n_sq_factors, $lb_sq_factors);

        my $rest_of_factors_product = 1;

        foreach my $i (@$n_times_lb)
        {
            $rest_of_factors_product *= $i;
        }

        my $low_square_val = int(sqrt($n/$rest_of_factors_product));
        my $high_square_val = int(sqrt($lower_bound/$rest_of_factors_product));
        
        if ($low_square_val != $high_square_val)
        {
            return ($lower_bound, [$n, ($low_square_val+1)*($low_square_val+1)*$rest_of_factors_product,$lower_bound]);
        }
    }

    # %primes_to_ids_map maps each prime number to its ID. IDs are consective.
    my (%primes_to_ids_map);
    my $next_id = 0;

    # @base is an array that for each ID of a prime number holds the 
    # controlling vector for this number.
    #
    # This is in fact a matrix that is kept stair-shaped and canonized.
    my (@base);

    # The integers whose multiplication compose this vector
    my (@base_composition);

    # Register all the primes in the squaring factors of $n
    foreach my $p (@$n_sq_factors)
    {
        $primes_to_ids_map{$p} = ($next_id++);
    }

    # $n_vec is used to determine if $n can be composed out of the base's 
    # vectors.
    my $n_vec = $n_sq_factors;

    my $n_composition = [ $n ];

    for(my $i=$n+1;;$i++)
    {
        my $i_sq_factors = get_squaring_factors($i);

        # Skip perfect squares - they do not add to the solution
        if (scalar(@$i_sq_factors) == 0)
        {
            next;
        }

        # Check if $i is a prime number
        # We need n > 2 because for n == 2 it does include a prime number.
        #
        # Prime numbers cannot be included because 2*n is an upper bound
        # to G(n) and so if there is a prime p > n than its next mulitple
        # will be greater than G(n).
        if (($n > 2) && ($i_sq_factors->[0] == $i))
        {
            next;
        }

        # $final_vec is the new vector to add after it was
        # stair-shaped by all the controlling vectors in the base.

        my $final_vec = $i_sq_factors;

        my $final_composition = [ $i ];

        foreach my $p (@$i_sq_factors)
        {
            if (!exists($primes_to_ids_map{$p}))
            {
                # Register a new prime number
                $primes_to_ids_map{$p} = ($next_id++);
            }
            else
            {
                my $id = $primes_to_ids_map{$p};
                if (defined($base[$id]))
                {
                    $final_vec = multiply_squaring_factors($final_vec, $base[$id]);
                    $final_composition = multiply_squaring_factors($final_composition, $base_composition[$id]);
                }
            }
        }

        # Get the minimal ID and its corresponding prime number
        # in $final_vec.
        my $min_id = -1;
        my $min_p = 0;

        foreach my $p (@$final_vec)
        {
            my $id = $primes_to_ids_map{$p};
            if (($min_id < 0) || ($min_id > $id))
            {
                $min_id = $id;
                $min_p = $p;
            }
        }

        if ($min_id >= 0)
        {
            # Assign $final_vec as the controlling vector for this prime
            # number
            $base[$min_id] = $final_vec;
            $base_composition[$min_id] = $final_composition;
            # Canonize the rest of the vectors with the new vector.
            for(my $j=0;$j<scalar(@base);$j++)
            {
                next if ($j == $min_id);
                next if (! defined($base[$j]));
                if (grep { $_ == $min_p } @{$base[$j]})
                {
                    $base[$j] = multiply_squaring_factors($base[$j], $final_vec);
                    $base_composition[$j] = multiply_squaring_factors($base_composition[$j], $final_composition);
                }
            }
        }

        # A closure to print the base. It is not used but can prove useful.
        my $print_base = sub {
            print "Base=\n\n";
            for(my $j=0;$j<scalar(@base);$j++)
            {
                next if (! defined($base[$j]));
                print "base[$j] (" . join(" * ", @{$base[$j]}) . ")\n";
            }
            print "\n\n";
        };

        # Check if we can form $n

        while (scalar(@$n_vec))
        {
            # Assing $id as the minimal ID of the squaring factors of $p
            my @ids_vec = (sort { $a <=> $b } @primes_to_ids_map{@$n_vec});
            my $id = $ids_vec[0];
            # Mulitply by the controlling vector of this ID if such one exists
            # or terminate if there isn't such.
            last if (!defined($base[$id]));
            $n_vec = multiply_squaring_factors($n_vec, $base[$id]);
            $n_composition = multiply_squaring_factors($n_composition, $base_composition[$id]);
        }
        if (scalar(@$n_vec) == 0)
        {
            return ($i, $n_composition);
        }
    }
}

my $start = shift;
my $end = shift || $start;
foreach my $n ($start .. $end)
{
    my ($g_val, $composition) = Graham($n);
    print "G($n) = " . $g_val . " [" . join(",", @$composition) . "]\n";
}


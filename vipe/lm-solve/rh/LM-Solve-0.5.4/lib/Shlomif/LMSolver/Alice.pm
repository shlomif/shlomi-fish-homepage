package Shlomif::LMSolver::Alice;

use strict;

use Shlomif::LMSolver::Base qw(%cell_dirs);

use vars qw(@ISA);

@ISA=qw(Shlomif::LMSolver::Base);


my %cell_flags =
    (
        'ADD' => 1,
        'SUB' => -1,
        'GOAL' => 0,
        'START' => 1,
        'BLANK' => 0,
    );

sub input_board
{
    my $self = shift;

    my $filename = shift;

    my $spec = 
    {
        'dims' => {'type' => "xy(integer)", 'required' => 1},
        'layout' => {'type' => "layout", 'required' => 1},
    };

    my $input_obj = Shlomif::LMSolver::Input->new();
    my $input_fields = $input_obj->input_board($filename, $spec);

    my ($width, $height) = @{$input_fields->{'dims'}->{'value'}}{'x','y'};

    my (@board);
    
    my $line;
    my $line_number=0;
    my $lines_ref = $input_fields->{'layout'}->{'value'};

    my $read_line = sub {
        if (scalar(@$lines_ref) == $line_number)
        {
            return 0;
        }
        $line = $lines_ref->[$line_number];
        $line_number++;
        return 1;
    };

    my $gen_exception = sub {
        my $text = shift;
        die "$text on $filename at line " . 
            ($input_fields->{'layout'}->{'line_num'} + $line_number + 1) . 
            "!\n";
    };


    my ($y,$x);
    my ($start_x,$start_y);

    $y = 0;
    $x = 0;

    INPUT_LOOP: while ($read_line->())
    {
        while (length($line) > 0)
        {
            $line =~ s/^\s+//;
            if ($line =~ /\S/)
            {                
                if ($line =~ /^\[([^\]]*)\]/)
                {
                    my $flags_string = uc($1);
                    my @flags = (split(/,/, $flags_string));
                    my @dirs = (grep { exists($cell_dirs{$_}) } @flags);
                    my @flag_flags = (grep { exists($cell_flags{$_}) } @flags);
                    my @unknown_flags = 
                        (grep 
                            { 
                                (!exists($cell_dirs{$_})) && 
                                (!exists($cell_flags{$_}))
                            }
                            @flags
                        );
                    if (scalar(@unknown_flags))
                    {
                        $gen_exception->("Unknown Flags on Cell (" . join(",", @unknown_flags) . ")");
                    }
                    $board[$y][$x] =
                        {
                            'dirs' => { map { $_ => $cell_dirs{$_} } @dirs },
                            'flags' => { map { $_ => $cell_flags{$_} } @flag_flags },
                        };

                    if (exists($board[$y][$x]->{'flags'}->{'START'}))
                    {
                        if (defined($start_x))
                        {
                            $gen_exception->("Two starts were defined!\n");
                        }
                        $start_x = $x;
                        $start_y = $y;
                    }
                    $x++;                    
                    if ($x == $width)
                    {
                        $x = 0;
                        $y++;
                        if ($y == $height)
                        {
                            last INPUT_LOOP;
                        }
                    }
                    $line =~ s/^.*?\]//;
                }
                elsif ($line =~ /^#/)
                {
                    # Do nothing - it's a comment
                    $line = "";
                }
                else
                {
                    $gen_exception->("Junk at Line");
                }
            }
        }
    }

    if ($y != $height)
    {
        $gen_exception->("Input Terminated Prematurely after reading y=$y x=$x");
    }

    if (! defined($start_x))
    {
        $gen_exception->("The Starting Position was not defined anywhere");
    }

    $self->{'height'} = $height;
    $self->{'width'} = $width;
    $self->{'board'} = \@board;

    return [ $start_x, $start_y, 1 ];
}

# A function that accepts the expanded state (as an array ref)
# and returns an atom that represents it.
sub pack_state
{
    my $self = shift;
    my $state_vector = shift;
    return pack("ccc", @{$state_vector});
}

# A function that accepts an atom that represents a state 
# and returns an array ref that represents it.
sub unpack_state
{
    my $self = shift;
    my $state = shift;
    return [ unpack("ccc", $state) ];
}

# Accept an atom that represents a state and output a 
# user-readable string that describes it.
sub display_state
{
    my $self = shift;
    my $state = shift;
    my ($x, $y, $d) = @{ $self->unpack_state($state) };
    return sprintf("X = %i ; Y = %i ; d = %i", $x+1, $y+1, $d);
}

# This function checks if a state it receives as an argument is a
# dead-end one.
sub check_if_unsolveable
{
    my $self = shift;
    my $coords = shift;
    return ($coords->[2] == 0);    
}

sub check_if_final_state
{
    my $self = shift;

    my $coords = shift;
    return exists($self->{'board'}->[$coords->[1]][$coords->[0]]->{'flags'}->{'GOAL'})
}

# This function enumerates the moves accessible to the state.
# If it returns a move, it still does not mean that it is a valid 
# one. I.e: it is possible that it is illegal to perform it.
sub enumerate_moves
{
    my $self = shift;

    my $coords = shift;
    return keys(%{$self->{'board'}->[$coords->[1]][$coords->[0]]->{'dirs'}});
}

# This function accepts a state and a move. It tries to perform the
# move on the state. If it is succesful, it returns the new state.
#
# Else, it returns undef to indicate that the move is not possible.
sub perform_move
{
    my $self = shift;

    my $coords = shift;
    my $m = shift;

    my $offsets = [ map { $_  * $coords->[2] } @{$cell_dirs{$m}} ];
    my @new_coords = @$coords;
    $new_coords[0] += $offsets->[0];
    $new_coords[1] += $offsets->[1];

    my $new_cell = $self->{'board'}->[$new_coords[1]][$new_coords[0]]->{'flags'};
    
    # Check if we are out of the bounds of the board.
    if (($new_coords[0] < 0) || ($new_coords[0] >= $self->{'width'}) ||
        ($new_coords[1] < 0) || ($new_coords[1] >= $self->{'height'}) ||
        exists($new_cell->{'BLANK'})
       )
    {
        return undef;
    }
    
    if (exists($new_cell->{'ADD'}))
    {
        $new_coords[2]++;
    }
    elsif (exists($new_cell->{'SUB'}))
    {
        $new_coords[2]--;
    }

    return [ @new_coords ];
}

1;


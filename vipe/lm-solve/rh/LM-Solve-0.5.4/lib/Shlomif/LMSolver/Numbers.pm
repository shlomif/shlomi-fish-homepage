package Shlomif::LMSolver::Numbers;

use strict;

use Shlomif::LMSolver::Base;

use vars qw(@ISA);

@ISA=qw(Shlomif::LMSolver::Base);

my %cell_dirs = 
    (
        'N' => [0,-1],
        'S' => [0,1],
        'E' => [1,0],
        'W' => [-1,0],
    );

sub input_board
{
    my $self = shift;

    my $filename = shift;

    my $spec = 
    {
        'dims' => {'type' => "xy(integer)", 'required' => 1},
        'start' => {'type' => "xy(integer)", 'required' => 1},
        'layout' => {'type' => "layout", 'required' => 1},
    };

    my $input_obj = Shlomif::LMSolver::Input->new();
    my $input_fields = $input_obj->input_board($filename, $spec); 
    my ($width, $height) = @{$input_fields->{'dims'}->{'value'}}{'x','y'};
    my ($start_x, $start_y) = @{$input_fields->{'start'}->{'value'}}{'x','y'};
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

    my $y = 0;

    INPUT_LOOP: while ($read_line->())
    {
        if (length($line) != $width)
        {
            $gen_exception->("Incorrect number of cells");
        }
        if ($line =~ /([^\d\*])/)
        {
            $gen_exception->("Unknown cell type $1");
        }
        push @board, [ split(//, $line) ];
        $y++;
        if ($y == $height)
        {
            last;
        }
    }

    if ($y != $height)
    {
        $gen_exception->("Input terminated prematurely after reading $y lines");
    }

    if (! defined($start_x))
    {
        $gen_exception->("The starting position was not defined anywhere");
    }

    $self->{'height'} = $height;
    $self->{'width'} = $width;
    $self->{'board'} = \@board;

    return [ $start_x, $start_y];
}

# A function that accepts the expanded state (as an array ref)
# and returns an atom that represents it.
sub pack_state
{
    my $self = shift;
    my $state_vector = shift;
    return pack("cc", @{$state_vector});
}

# A function that accepts an atom that represents a state 
# and returns an array ref that represents it.
sub unpack_state
{
    my $self = shift;
    my $state = shift;
    return [ unpack("cc", $state) ];
}

# Accept an atom that represents a state and output a 
# user-readable string that describes it.
sub display_state
{
    my $self = shift;
    my $state = shift;
    my ($x, $y) = @{ $self->unpack_state($state) };
    return sprintf("X = %i ; Y = %i", $x+1, $y+1);
}

# This function checks if a state it receives as an argument is a
# dead-end one.
sub check_if_unsolveable
{
    # One can always proceed from here.
    return 0;
}

sub check_if_final_state
{
    my $self = shift;

    my $coords = shift;
    return $self->{'board'}->[$coords->[1]][$coords->[0]] eq "*";
}

# This function enumerates the moves accessible to the state.
# If it returns a move, it still does not mean that it is a valid 
# one. I.e: it is possible that it is illegal to perform it.
sub enumerate_moves
{
    my $self = shift;

    my $coords = shift;

    my $x = $coords->[0];
    my $y = $coords->[1];

    my $step = $self->{'board'}->[$y][$x];

    my @moves;
    
    if ($x + $step < $self->{'width'})
    {
        push @moves, "E";
    }

    # The ranges are [0 .. ($width-1)] and [0 .. ($height-1)]
    if ($x - $step >= 0)
    {
        push @moves, "W";
    }

    if ($y + $step < $self->{'height'})
    {
        push @moves, "S";
    }

    if ($y - $step >= 0)
    {
        push @moves, "N";
    }
    
    return @moves;   
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

    my $step = $self->{'board'}->[$coords->[1]][$coords->[0]];

    my $offsets = [ map { $_  * $step } @{$cell_dirs{$m}} ];
    my @new_coords = @$coords;
    $new_coords[0] += $offsets->[0];
    $new_coords[1] += $offsets->[1];

    return [ @new_coords ];
}

1;


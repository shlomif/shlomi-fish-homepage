package Shlomif::LMSolver::Minotaur;

use strict;

use Shlomif::LMSolver::Base;

use Shlomif::LMSolver::Input;

use vars qw(@ISA);

@ISA=qw(Shlomif::LMSolver::Base);

sub input_board
{
    my $self = shift;
    my $filename = shift;

    my $spec = 
    {
        (map { $_ => { 'type' => "xy(integer)", 'required' => 1} } (qw(dims thes mino exit))),
        'layout' => { 'type' => "layout", 'required' => 1},
    };

    my $input_obj = Shlomif::LMSolver::Input->new();
    my $input_fields = $input_obj->input_board($filename, $spec);
    
    my ($width, $height) = @{$input_fields->{'dims'}->{'value'}}{'x','y'};    
    my ($thes_x, $thes_y) = @{$input_fields->{'thes'}->{'value'}}{'x','y'};
    my ($mino_x, $mino_y) = @{$input_fields->{'mino'}->{'value'}}{'x','y'};
    my ($exit_x, $exit_y) = @{$input_fields->{'exit'}->{'value'}}{'x','y'};

    if (($thes_x >= $width) || ($thes_y >= $height))
    {
        die "Theseus is out of bounds of the board in file \"$filename\"!\n";
    }

    if (($mino_x >= $width) || ($mino_y >= $height))
    {
        die "The minotaur is out of bounds of the board in file \"$filename\"!\n";
    }
    
    if (($exit_x >= $width) || ($exit_y >= $height))
    {
        die "The exit is out of bounds of the board in file \"$filename\"!\n";
    }

    my ($horiz_walls, $vert_walls) = 
        $input_obj->input_horiz_vert_walls_layout($width, $height, $input_fields->{'layout'});

    $self->{'width'} = $width;
    $self->{'height'} = $height;
    $self->{'exit_x'} = $exit_x;
    $self->{'exit_y'} = $exit_y;
    $self->{'horiz_walls'} = $horiz_walls;
    $self->{'vert_walls'} = $vert_walls;

    return [ $thes_x, $thes_y, $mino_x, $mino_y ];
}

sub mino_move
{
    my $self = shift;
    my $horiz_walls = $self->{'horiz_walls'};
    my $vert_walls = $self->{'vert_walls'};

    my ($thes_x, $thes_y, $mino_x, $mino_y) = @_; 
    for(my $t=0;$t<2;$t++)
    {
        if (($thes_x < $mino_x) && (! $vert_walls->[$mino_y][$mino_x]))
        {
            $mino_x--;
        }
        elsif (($thes_x > $mino_x) && (! $vert_walls->[$mino_y][$mino_x+1]))
        {
            $mino_x++;
        }
        elsif (($thes_y < $mino_y) && (! $horiz_walls->[$mino_y][$mino_x]))
        {
            $mino_y--;
        }
        elsif (($thes_y > $mino_y) && (! $horiz_walls->[$mino_y+1][$mino_x]))
        {
            $mino_y++;
        }
    }
    return ($mino_x, $mino_y);
}


# A function that accepts the expanded state (as an array ref)
# and returns an atom that represents it.
sub pack_state
{
    my $self = shift;
    my $state_vector = shift;
    return pack("cccc", @{$state_vector});
}

# A function that accepts an atom that represents a state 
# and returns an array ref that represents it.
sub unpack_state
{
    my $self = shift;
    my $state = shift;
    return [ unpack("cccc", $state) ];
}

# Accept an atom that represents a state and output a 
# user-readable string that describes it.
sub display_state
{
    my $self = shift;
    my $state = shift;
    my ($x, $y, $mx,$my) = (map { $_ + 1} @{ $self->unpack_state($state) });
    return sprintf("Thes=(%i,%i) Mino=(%i,%i)", $x, $y, $mx,$my);
}

# This function checks if a state it receives as an argument is a
# dead-end one.
sub check_if_unsolveable
{
    my $self = shift;
    my $coords = shift;
    return (($coords->[0] == $coords->[2]) && ($coords->[1] == $coords->[3]));
}

sub check_if_final_state
{
    my $self = shift;

    my $coords = shift;

    return (($coords->[0] == $self->{'exit_x'}) && ($coords->[1] == $self->{'exit_y'}));
}



# This function enumerates the moves accessible to the state.
# If it returns a move, it still does not mean that it is a valid 
# one. I.e: it is possible that it is illegal to perform it.
sub enumerate_moves
{
    my $self = shift;

    my $horiz_walls = $self->{'horiz_walls'};
    my $vert_walls = $self->{'vert_walls'};
    
    my $coords = shift;

    my ($thes_x, $thes_y) = @$coords[0..1];
    
    my @moves;

    if (! $vert_walls->[$thes_y][$thes_x])
    {
        push @moves, "l";
    }
    if (! $vert_walls->[$thes_y][$thes_x+1])
    {
        push @moves, "r";
    }
    if (! $horiz_walls->[$thes_y][$thes_x])
    {
        push @moves, "u";
    }
    if (! $horiz_walls->[$thes_y+1][$thes_x])
    {
        push @moves, "d";
    }
    push @moves, "w";

    return @moves;
    
}

my %translate_moves = 
    (
        "u" => [0, -1], 
        "d" => [0, 1], 
        "l" => [-1,0], 
        "r" => [1,0],
        "w" => [0,0],
    );

# This function accepts a state and a move. It tries to perform the
# move on the state. If it is succesful, it returns the new state.
#
# Else, it returns undef to indicate that the move is not possible.
sub perform_move
{
    my $self = shift;

    my $coords = shift;
    my $m = shift;

    my $offsets = $translate_moves{$m};
    my @new_coords = @$coords;
    $new_coords[0] += $offsets->[0];
    $new_coords[1] += $offsets->[1];
    (@new_coords[2 .. 3]) = $self->mino_move(@new_coords);

    return \@new_coords;
}

1;


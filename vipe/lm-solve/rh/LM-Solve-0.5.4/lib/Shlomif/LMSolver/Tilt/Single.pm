package Shlomif::LMSolver::Tilt::Single;

use strict;

use Shlomif::LMSolver::Tilt::Base;

use Shlomif::LMSolver::Input;

use vars qw(@ISA);

@ISA=qw(Shlomif::LMSolver::Tilt::Base);

sub input_board
{
    my $self = shift;
    my $filename = shift;
    
    my $spec = 
    {
        'dims' => { 'type' => "xy(integer)", 'required' => 1 },
        'start' => { 'type' => "xy(integer)", 'required' => 1 },
        'goal' => {'type' => "xy(integer)", 'required' => 1 },
        'layout' => { 'type' => "layout", 'required' => 1},
    };

    my $input_obj = Shlomif::LMSolver::Input->new();

    my $input_fields = $input_obj->input_board($filename, $spec);

    my ($width, $height) = @{$input_fields->{'dims'}->{'value'}}{'x','y'};
    my ($start_x, $start_y) = @{$input_fields->{'start'}->{'value'}}{'x','y'};
    my ($goal_x, $goal_y) = @{$input_fields->{'goal'}->{'value'}}{'x','y'};
    
    if (($start_x >= $width) || ($start_y >= $height))
    {
        die "The starting position is out of bounds of the board in file \"$filename\"!\n";        
    }

    if (($goal_x >= $width) || ($goal_y >= $height))
    {
        die "The goal position is out of bounds of the board in file \"$filename\"!\n";        
    }

    my ($horiz_walls, $vert_walls) = 
        $input_obj->input_horiz_vert_walls_layout($width, $height, $input_fields->{'layout'});

    $self->{'width'} = $width;
    $self->{'height'} = $height;
    $self->{'goal_x'} = $goal_x;
    $self->{'goal_y'} = $goal_y;
    $self->{'horiz_walls'} = $horiz_walls;
    $self->{'vert_walls'} = $vert_walls;
    
    return [ $start_x, $start_y ];    
}

sub pack_state
{
    my $self = shift;
    my $state_vector = shift;

    return pack("cc", @$state_vector);
}

sub unpack_state
{
    my $self = shift;
    my $state = shift;
    return [ unpack("cc", $state) ];
}

sub display_state
{
    my $self = shift;
    my $state = shift;
    my ($x, $y) = (map { $_ + 1} @{$self->unpack_state($state)});
    return sprintf("($x,$y)");
}

sub check_if_unsolveable
{
    my $self = shift;
    my $coords = shift;

    return 0;
}

sub check_if_final_state
{
    my $self = shift;

    my $coords = shift;

    return (($coords->[0] == $self->{'goal_x'}) && ($coords->[1] == $self->{'goal_y'}));
}

sub enumerate_moves
{
    my $self = shift;
    my $coords = shift;

    return (qw(u d l r));
}

sub perform_move
{
    my $self = shift;

    my $coords = shift;
    my $move = shift;

    my ($new_coords, $intermediate_states) = 
        $self->move_ball_to_end($coords, $move);
    
    return $new_coords;
}

1;
